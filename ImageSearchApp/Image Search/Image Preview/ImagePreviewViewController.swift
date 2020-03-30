//
//  ImagePreviewViewController.swift
//  ImageSearchApp
//
//  Created by nadun.eranga.baduge on 30/3/20.
//  Copyright © 2020 nadun.eranga.baduge. All rights reserved.
//

import UIKit

class ImagePreviewViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    private let image: UIImage
    
    init(with image: UIImage) {
        self.image = image
        super.init(nibName: "ImagePreviewViewController", bundle: Bundle.main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0
        scrollView.delegate = self
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension ImagePreviewViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
