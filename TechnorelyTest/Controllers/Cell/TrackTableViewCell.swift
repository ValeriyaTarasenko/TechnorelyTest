//
//  TrackTableViewCell.swift
//  TechnorelyTest
//
//  Created by Valeriia Tarasenko on 30.07.2020.
//  Copyright © 2020 Valeriia Tarasenko. All rights reserved.
//

import UIKit

class TrackTableViewCell: UITableViewCell {

    @IBOutlet private weak var trackInfoLabel: UILabel!
    
    func setup(with track: Track, index: Int) {
        trackInfoLabel.text = "\(index). \(track.name) (\(track.time))"
    }
}
