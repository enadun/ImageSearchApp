//
//  ImageCollectionViewCell.swift
//  ImageSearchApp
//
//  Created by nadun.eranga.baduge on 29/3/20.
//  Copyright © 2020 nadun.eranga.baduge. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    static let cellID = "ImageCollectionViewCell"
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    var vm: ImageCellViewModal? {
        didSet {
            imageView.image = nil //Placeholder image
            titleLabel.text = nil
            if let image = vm?.image {
                imageView.image = image
            }
            if let title = vm?.title {
                titleLabel.text = title
            }
        }
    }
    
    //Web search
    @IBAction func searchOnWebTapped(_ sender: Any) {
        
    }
}
