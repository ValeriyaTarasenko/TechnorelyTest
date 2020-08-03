//
//  HelpfullModels.swift
//  TechnorelyTest
//
//  Created by Valeriia Tarasenko on 30.07.2020.
//  Copyright © 2020 Valeriia Tarasenko. All rights reserved.
//

import Foundation

//for artists
struct TopArtists: Decodable {
    let topartists: ArtistData
}

struct ArtistData: Decodable {
    let artist: [Artist]
    let attribute: Attribute
    
    private enum CodingKeys : String, CodingKey {
        case artist = "artist"
        case attribute = "@attr"
    }
    init(artist: [Artist], attribute: Attribute) {
        self.artist = artist
        self.attribute = attribute
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.artist = try container.decode([Artist].self, forKey: .artist)
        self.attribute = try container.decode(Attribute.self, forKey: .attribute)
    }
}

struct Attribute: Decodable {
    let page: String
    let perPage: String
    let totalPages: String
    let total: String
}

//for albums
struct TopAlbums: Decodable {
    let topalbums: AlbumData
}

struct AlbumData: Decodable {
    let album: [Album]
    let attribute: Attribute
    
    private enum CodingKeys : String, CodingKey {
        case album = "album"
        case attribute = "@attr"
    }
    
    init(album: [Album], attribute: Attribute) {
        self.album = album
        self.attribute = attribute
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.album = try container.decode([Album].self, forKey: .album)
        self.attribute = try container.decode(Attribute.self, forKey: .attribute)
    }
}

//for tracks
struct albumStruct: Decodable {
    let album: Tracks
}
struct Tracks: Decodable {
    let tracks: TrackInside
}

struct TrackInside: Decodable {
    let track: [Track]
}

//
enum ManageMode {
    case dev, prod
}
