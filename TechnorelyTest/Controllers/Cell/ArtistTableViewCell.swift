//
//  ArtistTableViewCell.swift
//  TechnorelyTest
//
//  Created by Valeriia Tarasenko on 29.07.2020.
//  Copyright © 2020 Valeriia Tarasenko. All rights reserved.
//

import UIKit

class ArtistTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var artistImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var listenersLabel: UILabel!
    
    func setup(with artist: Artist) {
        nameLabel.text = artist.name
        listenersLabel.text = "(\(artist.listeners) listeners)"
        guard let url = artist.largeImageURL else {
            self.artistImageView.image = #imageLiteral(resourceName: "noImage")
            return }
        DispatchQueue.global(qos: .userInitiated).async {
            let contenst = try? Data(contentsOf: url)
            DispatchQueue.main.async {
                if let imageData = contenst {
                    self.artistImageView.image = UIImage(data: imageData)
                }
            }
        }
    }
}
