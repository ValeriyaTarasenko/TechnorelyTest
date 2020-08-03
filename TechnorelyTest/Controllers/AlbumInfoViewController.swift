//
//  AlbumInfoViewController.swift
//  TechnorelyTest
//
//  Created by Valeriia Tarasenko on 30.07.2020.
//  Copyright © 2020 Valeriia Tarasenko. All rights reserved.
//

import UIKit

class AlbumInfoViewController: BasicViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var albumInageView: UIImageView!
    
    private var album: Album? {
        didSet{
            title = album?.name
        }
    }
    private var artist: String?
    private var tracks: [Track] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        setAlbumImage()
        getInfo()
    }
    
    func update(with album: Album, artist: String?) {
        self.album = album
        self.artist = artist

    }
    
    private func setAlbumImage() {
        guard let album = album, let url = album.largeImageURL else {
            self.albumInageView.image = #imageLiteral(resourceName: "noImage")
            return}
        DispatchQueue.global(qos: .userInitiated).async {
            let contenst = try? Data(contentsOf: url)
            DispatchQueue.main.async {
                if let imageData = contenst {
                    self.albumInageView.image = UIImage(data: imageData)
                }
            }
        }
    }
    
    private func getInfo() {
        guard let album = album, let artist = artist else { return }//album.mbid
        dataManager?.getAlbumInfo(artist: artist, album: album.name) { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case let .success(tracks):
                self.tracks = tracks
                self.tableView.reloadData()
            case let .failure(error):
                self.showErrorMessage(error.localizedDescription)
            }
        }
    }
}

extension AlbumInfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TrackTableViewCell", for: indexPath) as? TrackTableViewCell,
            tracks.indices.contains(indexPath.row) else { return UITableViewCell() }
        cell.setup(with: tracks[indexPath.row], index: indexPath.row + 1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
