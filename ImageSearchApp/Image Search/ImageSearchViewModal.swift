//
//  ImageSearchViewModal.swift
//  ImageSearchApp
//
//  Created by nadun.eranga.baduge on 29/3/20.
//  Copyright © 2020 nadun.eranga.baduge. All rights reserved.
//

protocol ImageSearchViewModalType {
    func getImagesFor(keyword: String, completion: @escaping (Result<[Image], Error>) -> ())
}

class ImageSearchViewModal: ImageSearchViewModalType {
    private let dataManager: DataManagerType
    
    init(with dataManager: DataManagerType) {
        self.dataManager = dataManager
    }
    
    func getImagesFor(keyword: String, completion: @escaping (Result<[Image], Error>) -> ()) {
        dataManager.findImagesFor(keyword: keyword, completion: completion)
    }
    
}
