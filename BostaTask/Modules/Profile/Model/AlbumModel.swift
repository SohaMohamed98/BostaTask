//
//  AlbumModel.swift
//  BostaTask
//
//  Created by mac on 11/02/2023.
//

import Foundation
// MARK: - AlbumElement
struct AlbumElement: Codable {
    let userID, id: Int?
    let title: String?

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title
    }
}

typealias Albums = [AlbumElement]
