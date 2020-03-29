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
    func getImagesFor(keyword: String)
    func getImageCount() -> Int
    func getImageVMAt(index: Int) -> ImageCellViewModal
}

class ImageSearchViewModal: ImageSearchViewModalType {

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
        let image = images.value[index]
        let url = URL(string: image.url ?? "")
        return ImageCellViewModal(image: nil, title: image.title, url:url)
    }
    
}
