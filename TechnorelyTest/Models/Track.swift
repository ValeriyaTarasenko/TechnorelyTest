//
//  Track.swift
//  TechnorelyTest
//
//  Created by Valeriia Tarasenko on 30.07.2020.
//  Copyright © 2020 Valeriia Tarasenko. All rights reserved.
//

import Foundation
class Track: Decodable {
    let name: String
    let duration: String
    
    var time: String {
        guard let t = Int(duration) else { return "" }
        return "\((t % 3600) / 60):\((t % 3600) % 60)"
    }
    
    init(name: String, duration: String) {
        self.name = name
        self.duration = duration
    }
    
    convenience init(track: TrackRealm) {
        self.init(name: track.name, duration: track.duration)
    }
}
