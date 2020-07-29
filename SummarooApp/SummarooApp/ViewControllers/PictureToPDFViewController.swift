//
//  PictureToPDFViewController.swift
//  SummarooApp
//
//  Created by Bernadine Cawley on 5/23/20.
//  Copyright © 2020 Jake Cawley. All rights reserved.
//

import UIKit
import AVKit
import Vision
import VisionKit


struct PDFData {

    var backgroundImage: UIImage
}
class PictureToPDFViewController: UIViewController, AVCapturePhotoCaptureDelegate, AVCaptureVideoDataOutputSampleBufferDelegate, VNDocumentCameraViewControllerDelegate, UICollectionViewDelegate {

    
    fileprivate var data: [PDFData] = []
    
    fileprivate let collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(PDFCell.self, forCellWithReuseIdentifier: "cell")
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let scannerViewController = VNDocumentCameraViewController()
        scannerViewController.delegate = self
        present(scannerViewController, animated: true)
        // Do any additional setup after loading the view.
    }
    private func setupCollection(){
           view.addSubview(collectionView)
           collectionView.backgroundColor = UIColor.white.withAlphaComponent(0)
           collectionView.delegate = self
           collectionView.dataSource = self
           collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80).isActive = true
           collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
           collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
           collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80).isActive = true
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
                self.data.append(PDFData(backgroundImage: reloadedImage))
                self.setupCollection()
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


extension PictureToPDFViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width*1, height: collectionView.frame.width*1.5)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PDFCell
        cell.data = self.data[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            collectionView.deselectItem(at: indexPath, animated: true)
        
        //dont allow tap if text is not loaded
        let rowNumber : Int = indexPath.row
        print(data[rowNumber])
        }
    
}




class PDFCell: UICollectionViewCell {
    
    var data: PDFData? {
        didSet {
            guard let data = data else { return }
            PDFbg.image = data.backgroundImage
            
        }
    }
    
    fileprivate let PDFbg: UIImageView = {
       let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
                iv.layer.cornerRadius = 12
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        


        
        contentView.addSubview(PDFbg)

        PDFbg.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        PDFbg.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        PDFbg.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        PDFbg.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
