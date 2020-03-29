//
//  Config.swift
//  ImageSearchApp
//
//  Created by nadun.eranga.baduge on 29/3/20.
//  Copyright © 2020 nadun.eranga.baduge. All rights reserved.
//

struct Config {
    static let scheme = "https"
    static let requestTimeout = 10.0 //Seconds
    static let host = "contextualwebsearch-websearch-v1.p.rapidapi.com" //x-rapidapi-host
    static let apiKey = "KymJtJa61mmshgf55AM168kU84oHp12s57cjsnZBwWehuJp7DS" //x-rapidapi-key
}

struct APIEndPoint {
    static let imageSearch = "/api/Search/ImageSearchAPI"
}
