//
//  Modal.swift
//  ImageSearchApp
//
//  Created by nadun.eranga.baduge on 29/3/20.
//  Copyright © 2020 nadun.eranga.baduge. All rights reserved.
//

import UIKit

// MARK: - Message
struct Items: Codable {
    let type: String?
    let value: [Image]?

    enum CodingKeys: String, CodingKey {
        case type = "_type"
        case value
    }
}

// MARK: - Value
struct Image: Codable {
    let url: String?
    let height, width: Int?
    let thumbnail: String?
    let thumbnailHeight, thumbnailWidth: Int?
}
