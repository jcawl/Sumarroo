//
//  MyCollectionViewCell.swift
//  SummarooApp
//
//  Created by Bernadine Cawley on 5/22/20.
//  Copyright © 2020 Jake Cawley. All rights reserved.
//

import UIKit



class MyCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    static let nibid = "MyCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func configure(with image: UIImage){
        imageView.image = image
    }
    
    static func nib() -> UINib{
        return UINib(nibName: "MyCollectionViewCell", bundle: nil)
    }

}
