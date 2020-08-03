//
//  DatabaseService.swift
//  TechnorelyTest
//
//  Created by Valeriia Tarasenko on 03.08.2020.
//  Copyright © 2020 Valeriia Tarasenko. All rights reserved.
//

import Foundation
import Swinject

protocol DatabaseService {
    func getArtistsFromCache(completionHandler: @escaping (Result<ArtistData, AppError>) -> Void)
    func saveArtistsToCache(topArtists: ArtistData)
    func getAlbumsFromCache(artist: Artist, completionHandler: @escaping (Result<AlbumData, AppError>) -> Void)
    func saveAlbumsToCache(artistID: String, topAlbums: AlbumData)
    func getTracksFromCache(album: String, completionHandler: @escaping (Result<[Track], AppError>) -> Void)
    func saveTracksToCache(album: String, tracks: [Track])
}

class DatabaseServiceImplementation: DatabaseService {
    var realmDatabase: RealmDatabaseService
    
    init(realmDatabase: RealmDatabaseService) {
        self.realmDatabase = realmDatabase
        realmDatabase.start()
    }
    
    convenience init(resolver: Resolver) {
        let realmDatabase = resolver.resolve(RealmDatabaseService.self)!
        self.init(realmDatabase: realmDatabase)
    }
    
    func getArtistsFromCache(completionHandler: @escaping (Result<ArtistData, AppError>) -> Void) {
        guard let artistsRealm = self.realmDatabase.getObjects(ArtistRealm.self, filter: nil)?.sorted(byKeyPath: "index")
            else { return }
        let artists: [Artist] = artistsRealm.compactMap({ Artist(artist: $0) })
        let attribute = Attribute(page: "", perPage: "", totalPages: "", total: "")
        return completionHandler(.success(ArtistData(artist: artists, attribute: attribute)))
    }
    
    func saveArtistsToCache(topArtists: ArtistData) {
        let artistsForRealm = topArtists.artist.enumerated().map { (index, element) -> ArtistRealm in
            let ind = index + ((Int(topArtists.attribute.page) ?? 0) - 1) * (Int(topArtists.attribute.perPage) ?? 0)
            return ArtistRealm(artist: element, index: ind)}
        self.realmDatabase.saveObjects(objects: artistsForRealm)
    }
    
    func getAlbumsFromCache(artist: Artist, completionHandler: @escaping (Result<AlbumData, AppError>) -> Void) {
        let predicate = NSPredicate(format: "ANY artist.mbid = %@", argumentArray: [artist.mbid])
        guard let albumsRealm = self.realmDatabase.getObjects(AlbumRealm.self, filter: predicate)?.sorted(byKeyPath: "index")
           else { return }

        let albums: [Album] = albumsRealm.compactMap({ Album(album: $0) })
        let attribute = Attribute(page: "", perPage: "", totalPages: "", total: "")
        return completionHandler(.success(AlbumData(album: albums, attribute: attribute)))
    }
    
    func saveAlbumsToCache(artistID: String, topAlbums: AlbumData) {
        let predicate = NSPredicate(format: "mbid = %@", argumentArray: [artistID])
        if let realmArtist = self.realmDatabase.getObjects(ArtistRealm.self, filter: predicate)?.first {
            let albumsForRealm: [AlbumRealm] = topAlbums.album.enumerated().map {AlbumRealm(name: $0.element.name, index: $0.offset + ((Int(topAlbums.attribute.page) ?? 0) - 1) * (Int(topAlbums.attribute.perPage) ?? 0))}
            self.realmDatabase.saveObjects(objects: albumsForRealm)
            self.realmDatabase.updateObject {
                realmArtist.albums.append(objectsIn: albumsForRealm)
            }
        }
    }
    
    func getTracksFromCache(album: String, completionHandler: @escaping (Result<[Track], AppError>) -> Void) {
        let predicate = NSPredicate(format: "ANY album.name = %@", argumentArray: [album])
        guard let tracksRealm = self.realmDatabase.getObjects(TrackRealm.self, filter: predicate)?.sorted(byKeyPath: "index")
          else { return }
        let tracks:[Track] = tracksRealm.compactMap({Track(track: $0)})
        return completionHandler(.success(tracks))
    }
    
    func saveTracksToCache(album: String, tracks: [Track]) {
        let predicate = NSPredicate(format: "name = %@", argumentArray: [album])
        if let realmAlbum = self.realmDatabase.getObjects(AlbumRealm.self, filter: predicate)?.first {
            let trackForRealm = tracks.enumerated().map{
                TrackRealm(name: $0.element.name, duration: $0.element.duration, index: $0.offset)}
            self.realmDatabase.saveObjects(objects: trackForRealm)
            self.realmDatabase.updateObject {
                realmAlbum.tracks.append(objectsIn: trackForRealm)
            }
        }
    }
    
}
