//
//  PhotoCell.swift
//  BostaTask
//
//  Created by mac on 11/02/2023.
//

import UIKit
import SDWebImage
class PhotoCell: UICollectionViewCell {

    @IBOutlet private weak var uiPhotoImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func bindPhoto(photoModel: PhotoElement){
        self.uiPhotoImage.sd_setImage(with: URL(string: photoModel.url ?? ""), placeholderImage: UIImage(named: "TestImageLarge"))
    }
}
