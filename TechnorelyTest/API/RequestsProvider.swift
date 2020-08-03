//
//  RequestsProvider.swift
//  TechnorelyTest
//
//  Created by Valeriia Tarasenko on 29.07.2020.
//  Copyright © 2020 Valeriia Tarasenko. All rights reserved.
//

import Foundation
import Moya

let RequestsProvider = MoyaProvider<Requests>()

public enum Requests {
    case getTopArtists(Int, String)
    case getTopAlbums(Int, String)
    case getAlbumInfo(String, String)
}

extension Requests: TargetType {
   
    public var baseURL: URL {
        return URL(string: "http://ws.audioscrobbler.com/2.0/")!
    }
    
    public var path: String {
        return ""
    }
    
    public var method: Moya.Method {
        switch self {
        case .getTopArtists, .getTopAlbums, .getAlbumInfo:
            return .get
        }
    }
    
    public var parameters: [String : Any]? {
        var params: [String: Any] = [:]
        switch self {
        case .getTopArtists(let page, let country):
            params = ["method": "geo.gettopartists", "country": country, "page": page,
                      "api_key": "e81f61890b7ff8633ca024d0faa449e7", "format": "json"]
        case .getTopAlbums(let page, let artist):
            params = ["method": "artist.gettopalbums", "artist": artist, "page": page,
                      "api_key": "e81f61890b7ff8633ca024d0faa449e7", "format": "json"]
        case .getAlbumInfo(let artist, let album):
            params = ["method": "album.getInfo", "artist": artist, "album": album,
                      "api_key": "e81f61890b7ff8633ca024d0faa449e7", "format": "json"]
        }
        return params
    }
    
    public var task: Task {
        return .requestParameters(parameters: parameters ?? [:], encoding: parameterEncoding)
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var headers: [String: String]? {
        return nil
    }
    
    public var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
}
