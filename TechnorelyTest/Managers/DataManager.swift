//
//  DataManager.swift
//  TechnorelyTest
//
//  Created by Valeriia Tarasenko on 29.07.2020.
//  Copyright © 2020 Valeriia Tarasenko. All rights reserved.
//

import Foundation
import Alamofire
import Swinject

protocol DataManager {
    var manageMode: ManageMode { get }
    func getTopArtists(page: Int, country: String, completionHandler: @escaping (Result<ArtistData, AppError>) -> Void)
    func getTopAlbums(page: Int, artist: Artist, completionHandler: @escaping (Result<AlbumData, AppError>) -> Void)
    func getAlbumInfo(artist: String, album: String, completionHandler: @escaping (Result<[Track], AppError>) -> Void)
    func saveMode(with mode: Bool)
    func getMode() -> Bool
    func changeManageMode(to mode: ManageMode)
}

class DataManagerImplementation: DataManager {
    var manageMode: ManageMode = .prod
    
    let reachabilityManager = NetworkReachabilityManager()
    var databaseService: DatabaseService
    
    init(databaseService: DatabaseService) {
        self.databaseService = databaseService
        addListenReachability()
    }
    
    convenience init(resolver: Resolver) {
        let databaseService = resolver.resolve(DatabaseService.self)!
        self.init(databaseService: databaseService)
    }
    
    func getTopArtists(page: Int, country: String, completionHandler: @escaping (Result<ArtistData, AppError>) -> Void) {
        addOfflineView()
        guard shouldUseCache() else {
            return databaseService.getArtistsFromCache() { (result) in
                return completionHandler(result)
            }
        }
        let parameters: Requests = .getTopArtists(page, country)
        RequestsProvider.request(parameters) { result in
            let response = try? result.get()
            guard let data = response?.data else { return completionHandler(.failure(.unknown))}
            do {
                let allArtists = try TopArtists.decode(data: data)
                let topartists = allArtists.topartists
                self.databaseService.saveArtistsToCache(topArtists: topartists)
                completionHandler(.success(topartists))
            } catch let error {
                completionHandler(.failure(.custom(error.localizedDescription)))
            }
        }
    }
    
    func getTopAlbums(page: Int, artist: Artist, completionHandler: @escaping (Result<AlbumData, AppError>) -> Void) {
        guard shouldUseCache() else {
            return databaseService.getAlbumsFromCache(artist: artist) {(result) in
                return completionHandler(result)
            }
        }
        let parameters: Requests = .getTopAlbums(page, artist.name)
        RequestsProvider.request(parameters) { result in
            let response = try? result.get()
            guard let data = response?.data else { return completionHandler(.failure(.unknown))}
            do {
                let allAllbums = try TopAlbums.decode(data: data)
                let topalbums = allAllbums.topalbums
                self.databaseService.saveAlbumsToCache(artistID: artist.mbid, topAlbums: topalbums)
                completionHandler(.success(topalbums))
            } catch let error {
                completionHandler(.failure(.custom(error.localizedDescription)))
            }
        }
    }
    
    func getAlbumInfo(artist: String, album: String, completionHandler: @escaping (Result<[Track], AppError>) -> Void) {
        guard shouldUseCache() else {
            return databaseService.getTracksFromCache(album: album) {(result) in
                return completionHandler(result)
            }
        }
        let parameters: Requests = .getAlbumInfo(artist, album)
        RequestsProvider.request(parameters) { result in
            let response = try? result.get()
            guard let data = response?.data else { return completionHandler(.failure(.unknown))}
            do {
                let allTracks = try albumStruct.decode(data: data)
                self.databaseService.saveTracksToCache(album: album, tracks: allTracks.album.tracks.track)
                completionHandler(.success(allTracks.album.tracks.track))
            } catch let error {
                completionHandler(.failure(.custom(error.localizedDescription)))
            }
        }
    }
    
    func saveMode(with mode: Bool) {
        let defaults = UserDefaults.standard
        defaults.set(mode, forKey: "Mode")
        self.addOfflineView()
    }
    
    func getMode() -> Bool {
        let defaults = UserDefaults.standard
        return defaults.bool(forKey: "Mode")
    }

    func changeManageMode(to mode: ManageMode) {
        manageMode = mode
    }

    func addListenReachability() {
        reachabilityManager?.startListening(onUpdatePerforming: { status in
            self.addOfflineView()
        })
    }
    
    private func isReachable() -> Bool {
        guard let isReachable = reachabilityManager?.isReachable else { return false }
        return isReachable
    }
    
    private func shouldUseCache() -> Bool {
        guard isReachable() else { return false }
        if manageMode == .dev { return !getMode() }
        return true
    }
    
    private func addOfflineView() {
        let tag = 1000
        let screenSize = UIScreen.main.bounds
        let viewOffline = UIView()
        viewOffline.backgroundColor = .orange
        viewOffline.tag = tag
        
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: screenSize.width, height: 30))
        label.text = "Offline mode. You can't change country"
        guard let currentWindow = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first else { return }
        
        if shouldUseCache() {
            guard let viewWithTag = currentWindow.viewWithTag(tag) else { return }
            viewWithTag.removeFromSuperview()
        } else {
            guard currentWindow.viewWithTag(tag) == nil, (currentWindow.rootViewController as? ChooseModeViewController) == nil else { return }
            currentWindow.addSubview(viewOffline)
            viewOffline.addSubview(label)
            viewOffline.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                viewOffline.heightAnchor.constraint(equalToConstant: 30),
                viewOffline.bottomAnchor.constraint(equalTo: currentWindow.safeAreaLayoutGuide.bottomAnchor),
                viewOffline.leftAnchor.constraint(equalTo: currentWindow.safeAreaLayoutGuide.leftAnchor),
                viewOffline.rightAnchor.constraint(equalTo: currentWindow.safeAreaLayoutGuide.rightAnchor),
            ])
        }
    }
}
