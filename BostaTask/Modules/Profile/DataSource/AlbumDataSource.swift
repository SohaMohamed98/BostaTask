//
//  AlbumDataSource.swift
//  BostaTask
//
//  Created by mac on 11/02/2023.
//

import Foundation
import Differentiator


struct CustomCollectionDataSource{
    var header: String
    var items: [Item]
}

extension CustomCollectionDataSource: SectionModelType {
    typealias Item = AlbumElement
    typealias Header = String
    
    init(original: CustomCollectionDataSource, items: [Item]) {
        self = original
        self.items = items
    }
}
