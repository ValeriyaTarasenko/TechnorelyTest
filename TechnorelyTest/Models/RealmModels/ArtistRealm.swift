//
//  ArtistRealm.swift
//  TechnorelyTest
//
//  Created by Valeriia Tarasenko on 30.07.2020.
//  Copyright © 2020 Valeriia Tarasenko. All rights reserved.
//

import Foundation
import RealmSwift

class ArtistRealm: Object {
    @objc dynamic var index: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var listeners: String = ""
    @objc dynamic var mbid: String = ""
    
    var albums = List<AlbumRealm>()
    
    override public static func primaryKey() -> String? {
        return "mbid"
    }
    
    convenience init(artist: Artist, index: Int) {
        self.init()
        self.index = index
        self.name = artist.name
        self.listeners = artist.listeners
        self.mbid = artist.mbid
    }
}
