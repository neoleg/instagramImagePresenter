//
//  PhotoCollectionCell.swift
//  presenter
//
//  Created by DeveloperMB on 8/2/18.
//  Copyright © 2018 DeveloperMB. All rights reserved.
//

import UIKit

class PhotoCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    
    class func cellId () -> String {
        return "photoCell"
    }
}
