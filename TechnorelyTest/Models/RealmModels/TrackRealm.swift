//
//  TrackRealm.swift
//  TechnorelyTest
//
//  Created by Valeriia Tarasenko on 30.07.2020.
//  Copyright © 2020 Valeriia Tarasenko. All rights reserved.
//

import Foundation
import RealmSwift

class TrackRealm: Object {
    @objc dynamic var index: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var duration: String = ""
    
    var album = LinkingObjects(fromType: AlbumRealm.self, property: "tracks")
    
    override public static func primaryKey() -> String? {
        return "name"
    }
    
    convenience init(name: String, duration: String, index: Int) {
            self.init()

            self.name = name
            self.duration = duration
            self.index = index
        }
}
