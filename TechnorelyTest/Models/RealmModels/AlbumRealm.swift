//
//  AlbumRealm.swift
//  TechnorelyTest
//
//  Created by Valeriia Tarasenko on 30.07.2020.
//  Copyright © 2020 Valeriia Tarasenko. All rights reserved.
//

import Foundation
import RealmSwift

class AlbumRealm: Object {
    @objc dynamic var index: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var mbid: String = ""
    
    var artist = LinkingObjects(fromType: ArtistRealm.self, property: "albums")
    var tracks = List<TrackRealm>()
    
    override public static func primaryKey() -> String? {
        return "name"
    }
    
    convenience init(name: String, index: Int) {
        self.init()
        self.index = index
        self.name = name
    }
}
