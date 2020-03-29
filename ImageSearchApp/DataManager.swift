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
        let md5 = MD5(string: keyword.lowercased())
        let paths = getContentOfRequestCacheDirectory()
        //If md5 availabel retrive the file from storage
        if paths?.contains(md5) == true {
            do {
                if let data = loadRequestFromCacheWith(fileName: md5) {
                    let items = try JSONDecoder().decode(Items.self, from: data)
                    if let images = items.images {
                        return completion(.success(images))
                    }
                }
                loadAndSaveImages(keyword: keyword, completion: completion)
            } catch let error {
                completion(.failure(error))
            }
        } else {
            //Else download the content and save with the md5 name
            loadAndSaveImages(keyword: keyword, completion: completion)
        }
    }
    
    //MARK: - Private methods
    private func loadAndSaveImages(keyword: String, completion: @escaping (Result<[Image], Error>) -> ()) {
        let md5 = MD5(string: keyword.lowercased())
        api.searchImagesFor(keyword: keyword) { [weak self] result in
            switch result {
            case .success(let data):
                do {
                    let items = try JSONDecoder().decode(Items.self, from: data)
                    if let images = items.images {
                        self?.saveRequstToCashWith(data: data, md5: md5)
                        completion(.success(images))
                    }
                } catch let error {
                    completion(.failure(error))
                }
            //Send data
            case .failure(let error):
                return completion(.failure(error))
            }
        }
    }
    
    private func saveRequstToCashWith(data: Data, md5: String) {
        if let directory = getRequestCacheDirectory() {
            let path = directory.appendingPathComponent(md5)
                .appendingPathExtension("json")
            print(path.path)
            try? data.write(to: path)
        }
    }
    
    private func loadRequestFromCacheWith(fileName: String) -> Data? {
        do {
            if let filePath = getRequestCacheDirectory()?
                .appendingPathComponent(fileName)
                .appendingPathExtension("json") {
                let data = try Data(contentsOf: filePath)
                return data
            }
            return nil
        } catch _ {
            return nil
        }
    }
    
    
    private func getContentOfRequestCacheDirectory() -> [String]? {
        guard let directoryPath = getRequestCacheDirectory()?.path else { return nil }
        do {
            let paths = try manager.contentsOfDirectory(atPath: directoryPath)
                .map{ String($0.split(separator: ".").first ?? "") }
                .compactMap{ $0 }
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
        if let reqDirectory = getDocumentsDirectory()?
            .appendingPathComponent(cacheDirectoryName)
            .appendingPathComponent(direcotyName) {
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
        return nil
    }
    
    private func getDocumentsDirectory() -> URL? {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths.first
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
