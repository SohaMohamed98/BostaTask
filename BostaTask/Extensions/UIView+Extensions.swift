//
//  UIView+Extensions.swift
//  BostaTask
//
//  Created by mac on 11/02/2023.
//

import Foundation
import UIKit
extension UIView{
    func addSubviews(_ views: UIView...) {
        views.forEach({self.addSubview($0)})
    }
    
    
}
