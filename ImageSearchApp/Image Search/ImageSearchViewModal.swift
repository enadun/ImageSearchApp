//
//  ImageSearchViewModal.swift
//  ImageSearchApp
//
//  Created by nadun.eranga.baduge on 29/3/20.
//  Copyright © 2020 nadun.eranga.baduge. All rights reserved.
//

import UIKit

protocol ImageSearchViewModalType {
    var images: Box<[Image]> {get}
    var error: Box<Error?> {get}
    var mainImage: Box<UIImage?> {get}
    func getImagesFor(keyword: String)
    func getImageCount() -> Int
    func getImageVMAt(index: Int) -> ImageCellViewModal
    func loadImageAt(index: Int)
}

class ImageSearchViewModal: ImageSearchViewModalType {
    
    let mainImage: Box<UIImage?> = Box(nil)
    let images: Box<[Image]> = Box([])
    let error: Box<Error?> = Box(nil)
    
    private let dataManager: DataManagerType
    
    init(with dataManager: DataManagerType) {
        self.dataManager = dataManager
    }
    
    func getImagesFor(keyword: String) {
        dataManager.findImagesFor(keyword: keyword) {
            [weak self] result in
            switch result {
            case .success(let images):
                self?.images.value = images
            case .failure(let error):
                self?.error.value = error
            }
        }
    }
    
    func getImageCount() -> Int {
        return images.value.count
    }
    
    func getImageVMAt(index: Int) -> ImageCellViewModal {
        let imageObj = images.value[index]
        let url = URL(string: imageObj.url ?? "")
        let webUrl = URL(string: imageObj.imageWebSearchURL ?? "")
        let thumImage: Box<UIImage?> = Box(nil)
        if let imgURL = URL(string: imageObj.thumbnail ?? "") {
            dataManager.findImageFor(url: imgURL) { [weak self] result in
                switch result {
                case .success(let image):
                    thumImage.value = image
                case .failure(let error):
                    self?.error.value = error
                }
            }
        }
        return ImageCellViewModal(image: thumImage,
                                  title: imageObj.title,
                                  url: url,
                                  webUrl:webUrl )
    }
    
    func loadImageAt(index: Int) {
        if let url = URL(string: images.value[index].url ?? "") {
            dataManager.findImageFor(url: url) { [weak self] result in
                switch result {
                case .success(let image):
                    self?.mainImage.value = image
                case .failure(let error):
                    self?.error.value = error
                }
            }
        }
    }
}
