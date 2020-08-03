//
//  ArtistInfoTableViewCell.swift
//  TechnorelyTest
//
//  Created by Valeriia Tarasenko on 30.07.2020.
//  Copyright © 2020 Valeriia Tarasenko. All rights reserved.
//

import UIKit

class ArtistInfoTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var albumLabel: UILabel!
    
    func setup(with album: Album) {
        albumLabel.text = album.name
    }
}
