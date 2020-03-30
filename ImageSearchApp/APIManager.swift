//
//  ImageSearchAPI.swift
//  ImageSearchApp
//
//  Created by nadun.eranga.baduge on 29/3/20.
//  Copyright © 2020 nadun.eranga.baduge. All rights reserved.
//

import Foundation

/// Protocal definishen for both futrue change in the actual implementatin and crating the mock API manger for unit testing.
protocol ImageSearchAPIType {
    func searchImagesFor(keyword: String, completion: @escaping (Result<Data, Error>) -> ())
    func downloadImageFor(url: URL, completion: @escaping (Result<Data, Error>) -> ())
}

class APIManager: ImageSearchAPIType {
    
    private let headers = [ "x-rapidapi-host": Config.host,
                            "x-rapidapi-key": Config.apiKey ]
    private let session = URLSession.shared
    
    
    /// This method returns the response as a Data object for the given keywords.
    /// - Parameters:
    ///   - keyword: Keyword for search.
    ///   - completion: Completion handler for retrun the response data.
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
    
    
    /// This method will return the image data for given url.
    /// - Parameters:
    ///   - url: Url for download the image.
    ///   - completion: Completion handler retruns the data object of the image.
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
