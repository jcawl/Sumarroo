//
//  PictureToSummaryCollectionViewController.swift
//  
//
//  Created by Bernadine Cawley on 5/22/20.
//

import UIKit
import AVKit
import Vision
import VisionKit

private let reuseIdentifier = "Cell"

class PictureToSummaryCollectionViewController: UICollectionViewController, AVCapturePhotoCaptureDelegate, AVCaptureVideoDataOutputSampleBufferDelegate, VNDocumentCameraViewControllerDelegate{

    var textRecognitionRequest = VNRecognizeTextRequest(completionHandler: nil)
    private let textRecognitionWorkQueue = DispatchQueue(label: "MyVisionScannerQueue", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
    
    var collectionArray: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVision()
        let scannerViewController = VNDocumentCameraViewController()
        scannerViewController.delegate = self
        present(scannerViewController, animated: true)

        // Register cell classes
        title = "Selfie Share"

        // Do any additional setup after loading the view.
    }
    
    //setup text recognition
    private func setupVision() {
        //set recognition
        textRecognitionRequest.recognitionLevel = .accurate
        textRecognitionRequest.usesLanguageCorrection = true
        textRecognitionRequest = VNRecognizeTextRequest { (request, error) in
            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
            
            var detectedText = ""
            for observation in observations {
                guard let topCandidate = observation.topCandidates(1).first else { return }
                print("text \(topCandidate.string) has confidence \(topCandidate.confidence)")
                
                detectedText += topCandidate.string
                
            }
            //load and send text to api
            DispatchQueue.main.async {
                //self.getPrediction(text: detectedText)
            }
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
               let reloadedImage = UIImage(data: imageData) else {return}
        collectionArray.append(reloadedImage)
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
                 
             }

         
    
     // let newImage = compressedImage(image)
         
     }


    // MARK: UICollectionViewDataSource


  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageView", for: indexPath)

        if let imageView = cell.viewWithTag(1000) as? UIImageView {
            imageView.image = collectionArray[indexPath.item]
        }

        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
