//
//  ImageSearchAPI.swift
//  ImageSearchApp
//
//  Created by nadun.eranga.baduge on 29/3/20.
//  Copyright © 2020 nadun.eranga.baduge. All rights reserved.
//

import Foundation

protocol ImageSearchAPIType {
    func searchImagesFor(keyword: String, completion: @escaping (Result<Data, Error>) -> ())
    func downloadImageFor(url: URL, completion: @escaping (Result<Data, Error>) -> ())
}

class APIManager: ImageSearchAPIType {
    
    private let headers = [ "x-rapidapi-host": Config.host,
                            "x-rapidapi-key": Config.apiKey ]
    private let session = URLSession.shared
    
    func searchImagesFor(keyword: String, completion: @escaping (Result<Data, Error>) -> ()) {
        //Setting the query parameters
        var queryParams: [URLQueryItem] = []
        queryParams.append(URLQueryItem(name: "autoCorrect", value: "false"))
        queryParams.append(URLQueryItem(name: "pageNumber", value: "1"))
        queryParams.append(URLQueryItem(name: "pageSize", value: "10"))
        queryParams.append(URLQueryItem(name: "q", value: keyword))
        queryParams.append(URLQueryItem(name: "safeSearch", value: "false"))
        //Setting the url components
        var urlComponents = URLComponents()
        urlComponents.scheme = Config.scheme
        urlComponents.host = Config.host
        urlComponents.path = APIEndPoint.imageSearch
        urlComponents.queryItems = queryParams
        //Creating request
        guard let url = urlComponents.url
            else {
                return completion(.failure(NSError(domain: "", code: 100, userInfo: nil)))
        }
        var request = URLRequest(url: url,
                                 cachePolicy: .useProtocolCachePolicy,
                                 timeoutInterval: Config.requestTimeout)
        request.allHTTPHeaderFields = headers
        request.httpMethod = "GET"
        //Creating data task
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                return completion(.failure(error))
            }
            if let data = data {
                return completion(.success(data))
            }
            return completion(.failure(NSError(domain: "", code: 100, userInfo: nil)))
        }
        dataTask.resume()
    }
    
    func downloadImageFor(url: URL, completion: @escaping (Result<Data, Error>) -> ()) {
        let request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy,
                                 timeoutInterval: Config.requestTimeout)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                return completion(.failure(error))
            }
            if let data = data {
                return completion(.success(data))
            }
            return completion(.failure(NSError(domain: "", code: 100, userInfo: nil)))
        }.resume()
    }
}
