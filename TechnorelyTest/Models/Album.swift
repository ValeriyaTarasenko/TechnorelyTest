//
//  Album.swift
//  TechnorelyTest
//
//  Created by Valeriia Tarasenko on 30.07.2020.
//  Copyright © 2020 Valeriia Tarasenko. All rights reserved.
//

import Foundation
class Album: Decodable {
    let name: String
    let image: [ImageData]
    
    var largeImageURL: URL? {
        guard let imageData = image.first(where: { $0.imageSize == .large }) else { return nil}
        return URL(string: imageData.text)
    }
    
    init(name: String, image: [ImageData]) {
        self.name = name
        self.image = image
    }
    
    convenience init(album: AlbumRealm) {
        self.init(name: album.name, image: [])
    }
}
