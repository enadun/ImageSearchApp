//
//  DataManager.swift
//  ImageSearchApp
//
//  Created by nadun.eranga.baduge on 29/3/20.
//  Copyright © 2020 nadun.eranga.baduge. All rights reserved.
//

import UIKit

protocol DataManagerType {
    func findImagesFor(keyword: String, completion: @escaping (Result<[Image], Error>) -> ())
}

class DataManager: DataManagerType {
    
    private let api: ImageSearchAPIType
    private let cacheDirectoryName = "cache"
    private let requestsCacheDriectoryName = "requests"
    private let imageCacheDriectoryName = "images"
    private let manager = FileManager.default
    
    init(with api: ImageSearchAPIType) {
        self.api = api
    }
    
    func findImagesFor(keyword: String, completion: @escaping (Result<[Image], Error>) -> ()) {
        let md5 = MD5(string: keyword)
        //If md5 availabel retrive the file from storage
        //Else download the content and save with the md5 name
        api.searchImagesFor(keyword: keyword) { [weak self] result in
            switch result {
            case .success(let data):
                //Save data
                self?.saveRequstToCashWith(data: data, md5: md5)
                //Send data
            case .failure(let error):
                return completion(.failure(error))
            }
        }
    }
    
    //MARK: - Private methods
    private func saveRequstToCashWith(data: Data, md5: String) {
        if let directory = getRequestCacheDirectory() {
            let path = directory.appendingPathComponent(md5)
                .appendingPathExtension("json")
            print(path.path)
            try? data.write(to: path)
        }
    }
    
    
    private func getContentOfRequestCacheDirectory() -> [String]? {
        guard let directoryPath = getRequestCacheDirectory()?.path else { return nil }
        do {
            let paths = try manager.contentsOfDirectory(atPath: directoryPath)
            print(paths)
            return paths
        } catch {
            return nil
        }
    }
    
    private func getRequestCacheDirectory() -> URL? {
        return getCacheDirectoryFor(direcotyName: requestsCacheDriectoryName)
    }
    
    private func getImageCacheDirectory() -> URL? {
        return getCacheDirectoryFor(direcotyName: imageCacheDriectoryName)
    }
    
    private func getCacheDirectoryFor(direcotyName: String) -> URL? {
        let reqDirectory = getDocumentsDirectory()
            .appendingPathComponent(cacheDirectoryName)
            .appendingPathComponent(direcotyName)
        //Checking the directotry is exist, othervise create before returning the path.
        if !manager.fileExists(atPath: reqDirectory.path) {
            do {
                try manager.createDirectory(at: reqDirectory, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error)
                return nil
            }
        }
        return reqDirectory
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    //    private func save(text: String,
    //                      withFileName fileName: String) {
    //        let filename = getDocumentsDirectory().appendingPathComponent(fileName)
    //        print("File name: ", filename.description)
    //        do {
    //            try text.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
    //        } catch {
    //        }
    //    }
}
