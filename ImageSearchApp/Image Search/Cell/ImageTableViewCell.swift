//
//  ImageCollectionViewCell.swift
//  ImageSearchApp
//
//  Created by nadun.eranga.baduge on 29/3/20.
//  Copyright © 2020 nadun.eranga.baduge. All rights reserved.
//

import UIKit

protocol ImageCellDelegate: NSObject {
    func searchOnWebWith(url: URL)
}

class ImageTableViewCell: UITableViewCell {
    static let cellID = "ImageTableViewCell"
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    weak var delegate: ImageCellDelegate?
    var vm: ImageCellViewModal? {
        didSet {
            thumbImageView.image = nil //Placeholder image
            titleLabel.text = nil
            if let imageBox = vm?.image {
                imageBox.bind { [weak self] image in
                    DispatchQueue.main.async {
                        self?.thumbImageView.image = image
                    }
                }
            }
            if let title = vm?.title {
                titleLabel.text = title
            }
        }
    }
    
    //Web search
    @IBAction func searchOnWebTapped(_ sender: Any) {
        if let url = vm?.webUrl {
            delegate?.searchOnWebWith(url: url)
        }
    }
}
