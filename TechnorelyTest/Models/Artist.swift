//
//  Artist.swift
//  TechnorelyTest
//
//  Created by Valeriia Tarasenko on 29.07.2020.
//  Copyright © 2020 Valeriia Tarasenko. All rights reserved.
//

import Foundation
class Artist: Decodable {
    var name: String
    var listeners: String
    var mbid: String
    
    var url: String
    let image: [ImageData]
    
    var largeImageURL: URL? {
        guard let imageData = image.first(where: { $0.imageSize == .large }) else { return nil }
        return URL(string: imageData.text)
    }
    
    init(name: String, listeners: String, mbid: String, url: String, image: [ImageData]) {
        self.name = name
        self.listeners = listeners
        self.mbid = mbid
        self.url = url
        self.image = image
    }
    
    convenience init(artist: ArtistRealm) {
        self.init(name: artist.name, listeners: artist.listeners, mbid: artist.mbid, url: "", image: [])
    }
}

