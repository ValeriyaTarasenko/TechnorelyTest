//
//  ArtistInfoViewController.swift
//  TechnorelyTest
//
//  Created by Valeriia Tarasenko on 30.07.2020.
//  Copyright © 2020 Valeriia Tarasenko. All rights reserved.
//

import UIKit

class ArtistInfoViewController: BasicViewController {

    @IBOutlet private weak var tableView: UITableView!
    
    var artist: Artist? {
        didSet{
            title = artist?.name
//            getInfo(page: 1)
        }
    }
    private var albums: [Album] = []
    private var lastPageAttributes: Attribute?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        getInfo(page: 1)
    }
    
    func update(with artist: Artist) {
        self.artist = artist
//        getInfo(page: 1)
    }
    
    private func getInfo(page: Int) {
        guard let artist = artist else { return }
        dataManager?.getTopAlbums(page: page, artist: artist) { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case let .success(albumsData):
                self.albums += albumsData.album
                self.lastPageAttributes = albumsData.attribute
                self.tableView.reloadData()
            case let .failure(error):
                self.showErrorMessage(error.localizedDescription)
            }
        }
    }
}

extension ArtistInfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArtistInfoTableViewCell", for: indexPath) as? ArtistInfoTableViewCell,
            albums.indices.contains(indexPath.row) else { return UITableViewCell() }
        cell.setup(with: albums[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == albums.count - 1,
            let currentPage = lastPageAttributes?.page, let currentPageInt = Int(currentPage),
            let total = lastPageAttributes?.total, let totalInt = Int(total),
            let perPage = lastPageAttributes?.perPage, let perPageInt = Int(perPage),
            (totalInt/perPageInt + 1) > currentPageInt {
            getInfo(page: currentPageInt + 1)
        }
    }
}

extension ArtistInfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard albums.indices.contains(indexPath.row) else { return }
        guard let albumInfoController = presentViewController(withIdentifier: "AlbumInfo", fromNavigation: true) as? AlbumInfoViewController else {
            return
        }
        albumInfoController.update(with: albums[indexPath.row], artist: artist?.name)
    }
}
