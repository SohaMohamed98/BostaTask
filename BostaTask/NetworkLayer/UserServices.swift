//
//  ServiceUser.swift
//  BostaTask
//
//  Created by mac on 11/02/2023.
//

import Foundation
import Moya

enum UserServices: TargetType{
    var baseURL: URL{
        return URL(string: NetworkConstant.baseURL)!
    }
    
    var path: String {
        switch self{
        case .getUsers:
            return "users"
        case .getAlbums:
            return "albums"
        case .getPhotos:
            return "photos"
        }
    }
    
    var method: Moya.Method{
        switch self{
         default:
            return .get
            
        }
    }
    
    var task: Moya.Task{
        switch self{
        case let .getAlbums(userId: userId):
            return .requestParameters(parameters: ["userId": userId], encoding: URLEncoding.default)
        case let .getPhotos(albumId: albumId):
            return .requestParameters(parameters: ["albumId": albumId], encoding: URLEncoding.default)
         default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]?{
        return ["Content-Typer": "Application/json"]
    }
    
    
    case getUsers
    case getAlbums(userId: Int)
    case getPhotos(albumId: Int)
}
