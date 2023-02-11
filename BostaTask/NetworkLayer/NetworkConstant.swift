//
//  NetworkConstant.swift
//  BostaTask
//
//  Created by mac on 11/02/2023.
//

import Foundation
enum BaseURLS: String{
    case LIVE = "https://jsonplaceholder.typicode.com/"
    
}
class NetworkConstant{
    static let baseURL: String = BaseURLS.LIVE.rawValue
}
