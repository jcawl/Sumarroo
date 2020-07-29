//
//  PictureToTextViewController.swift
//  SummarooApp
//
//  Created by Bernadine Cawley on 5/22/20.
//  Copyright © 2020 Jake Cawley. All rights reserved.
//

import UIKit
import AVKit
import Vision
import VisionKit


struct CustomData {

    var backgroundImage: UIImage
}

class PictureToTextViewController: UIViewController, AVCapturePhotoCaptureDelegate, AVCaptureVideoDataOutputSampleBufferDelegate, VNDocumentCameraViewControllerDelegate, UICollectionViewDelegate {
    
    fileprivate var data: [CustomData] = []
    fileprivate var text: [String] = []
    var cellText = ""
   
    fileprivate let collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(CustomCell.self, forCellWithReuseIdentifier: "cell")
        return cv
    }()

    var textRecognitionRequest = VNRecognizeTextRequest(completionHandler: nil)
       private let textRecognitionWorkQueue = DispatchQueue(label: "MyVisionScannerQueue", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
       
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVision()
        let scannerViewController = VNDocumentCameraViewController()
        scannerViewController.delegate = self
        present(scannerViewController, animated: true)
    }
    
    
    private func setupCollection(){
        view.addSubview(collectionView)
        collectionView.backgroundColor = UIColor.white.withAlphaComponent(0)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 80).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: view.frame.width/2).isActive = true
    }
    //setup text recognition
    private func setupVision() {
        //set recognition
        textRecognitionRequest.recognitionLevel = .accurate
        textRecognitionRequest.usesLanguageCorrection = true
        textRecognitionRequest = VNRecognizeTextRequest { (request, error) in
            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
            
            var detectedText = ""
            var cleanedText = ""
            for observation in observations {
                guard let topCandidate = observation.topCandidates(1).first else { return }
                print("text \(topCandidate.string) has confidence \(topCandidate.confidence)")
                
                detectedText += topCandidate.string
                cleanedText = detectedText.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            //load and send text to api
            DispatchQueue.main.async {
                self.text.append(cleanedText)
            }
        }
        
    }
    private func recognizeTextInImage(_ image: UIImage) {
                guard let cgImage = image.cgImage else { return }
                   
                   textRecognitionWorkQueue.async {
                       let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
                       do {
                           try requestHandler.perform([self.textRecognitionRequest])
                       } catch {
                           print(error)
                       }
                   }
               }
    
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        guard scan.pageCount >= 1 else {
            controller.dismiss(animated: true)
            return
        }
         for i in 0 ..< scan.pageCount {
                let img = scan.imageOfPage(at: i)
                controller.dismiss(animated: true)
            compressedImage(img)
            recognizeTextInImage(img)
            }
    }
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        print(error)
        controller.dismiss(animated: true)
    }
    
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        controller.dismiss(animated: true)
    }
    
    func compressedImage(_ originalImage: UIImage){
        guard let imageData = originalImage.jpegData(compressionQuality: 1),
            let reloadedImage = UIImage(data: imageData) else {
                return
        }
            self.data.append(CustomData(backgroundImage: reloadedImage))
            self.setupCollection()
    }
}

extension PictureToTextViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/4, height: collectionView.frame.width/3)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCell
        cell.data = self.data[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            collectionView.deselectItem(at: indexPath, animated: true)
        
        //dont allow tap if text is not loaded
        guard (text.count == data.count) else {
            print("loading")
            return
        }

        let rowNumber : Int = indexPath.row
        cellText = text[rowNumber]
        self.performSegue(withIdentifier: "ShowText", sender: nil)
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! TextPopUpViewController
        vc.modalPresentationStyle = .automatic
        vc.string = self.cellText
    }
}




class CustomCell: UICollectionViewCell {
    
    var data: CustomData? {
        didSet {
            guard let data = data else { return }
            bg.image = data.backgroundImage
            
        }
    }
    
    fileprivate let bg: UIImageView = {
       let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
                iv.layer.cornerRadius = 12
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        


        
        contentView.addSubview(bg)

        bg.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        bg.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        bg.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        bg.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//class PictureToTextViewController: UIViewController, AVCapturePhotoCaptureDelegate, AVCaptureVideoDataOutputSampleBufferDelegate{
//
//    @IBOutlet weak var collectionView: UICollectionView!
//
//    var collectionArray: [UIImage] = []
//    var count = 0
//
//    let layout = UICollectionViewFlowLayout()
//
//
//
//
//
//    var textRecognitionRequest = VNRecognizeTextRequest(completionHandler: nil)
//      private let textRecognitionWorkQueue = DispatchQueue(label: "MyVisionScannerQueue", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//       setupVision()
//               let scannerViewController = VNDocumentCameraViewController()
//                    scannerViewController.delegate = self
//                    present(scannerViewController, animated: true)
//         layout.itemSize = CGSize(width: 120, height: 150)
//                collectionView.collectionViewLayout = layout
//                collectionView.register(MyCollectionViewCell.nib(), forCellWithReuseIdentifier: MyCollectionViewCell.nibid)
//                collectionView.delegate = self
//                collectionView.dataSource = self
//
//
//
//
//        // Do any additional setup after loading the view.
//    }
//
//
//    private func processImage(_ i: UIImage) {
//    //     imageView.image = i
//     //    recognizeTextInImage(i)
//
//     }
//
//    //setup text recognition
//       private func setupVision() {
//
//           //set recognition
//           textRecognitionRequest.recognitionLevel = .accurate
//           textRecognitionRequest.usesLanguageCorrection = true
//           textRecognitionRequest = VNRecognizeTextRequest { (request, error) in
//               guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
//
//               var detectedText = ""
//               for observation in observations {
//                   guard let topCandidate = observation.topCandidates(1).first else { return }
//                   print("text \(topCandidate.string) has confidence \(topCandidate.confidence)")
//
//                   detectedText += topCandidate.string
//
//               }
//               //load and send text to api
//               DispatchQueue.main.async {
//
//                print(detectedText)
//                 //  self.getPrediction(text: detectedText)
//               }
//           }
//
//       }
//
//     private func recognizeTextInImage(_ image: [UIImage]) {
//         for img in image{
//              guard let cgImage = img.cgImage else { return }
//           //  textView.text = ""
//
//                 textRecognitionWorkQueue.async {
//                     let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
//                     do {
//                         try requestHandler.perform([self.textRecognitionRequest])
//                     } catch {
//                         print(error)
//                     }
//                 }
//             }
//
//         }
//
//    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
//            guard scan.pageCount >= 1 else {
//                controller.dismiss(animated: true)
//                return
//            }
//            var imageArray: [UIImage] = []
//             for i in 0 ..< scan.pageCount {
//                    let img = scan.imageOfPage(at: i)
//                    controller.dismiss(animated: true)
//                imageArray.append(img)
//
//                }
//             collectionArray = imageArray
//             recognizeTextInImage(imageArray)
//
//
//        // let newImage = compressedImage(image)
//
//
//
//        // processImage(newImage)
//        }
//
//}
//
//extension PictureToTextViewController: VNDocumentCameraViewControllerDelegate{
//
//    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
//        print(error)
//        controller.dismiss(animated: true)
//    }
//
//    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
//        controller.dismiss(animated: true)
//    }
//
//    func compressedImage(_ originalImage: UIImage) -> UIImage {
//        guard let imageData = originalImage.jpegData(compressionQuality: 1),
//            let reloadedImage = UIImage(data: imageData) else {
//                return originalImage
//        }
//        return reloadedImage
//    }
//}
//
//extension PictureToTextViewController: UICollectionViewDelegate{
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        collectionView.deselectItem(at: indexPath, animated: true)
//        print("tapped")
//    }
//}
//
//extension PictureToTextViewController: UICollectionViewDataSource{
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        for _ in 0 ..< collectionArray.count {
//            count += 1
//        }
//        return count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyCollectionViewCell.nibid, for: indexPath) as! MyCollectionViewCell
//
//        for i in 0 ..< collectionArray.count {
//            cell.imageView.image =  collectionArray[i]
//        }
//          return cell
//    }
//}
//
//
//extension PictureToTextViewController: UICollectionViewDelegateFlowLayout{
//
//    func collectionView( _ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
//        return CGSize(width: 120, height: 150)
//    }
//}
