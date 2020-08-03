//
//  ImageData.swift
//  TechnorelyTest
//
//  Created by Valeriia Tarasenko on 30.07.2020.
//  Copyright © 2020 Valeriia Tarasenko. All rights reserved.
//

import Foundation
class ImageData: Decodable {
    let text: String
    private let size: String
    
    var imageSize: ImageSize {
        return ImageSize.init(rawValue: size) ?? .small
    }
    
    enum ImageSize: String {
        case small, medium, large, extralarge, mega
    }
    
    private enum CodingKeys : String, CodingKey {
        case text = "#text"
        case size = "size"
    }
    
    init(text: String, size: String) {
        self.text = text
        self.size = size
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.text = try container.decode(String.self, forKey: .text)
        self.size = try container.decode(String.self, forKey: .size)
    }
}
