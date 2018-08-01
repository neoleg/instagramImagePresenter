//
//  ProfileViewCell.swift
//  instagramImagePresenter
//
//  Created by DeveloperMB on 8/1/18.
//  Copyright © 2018 DeveloperMB. All rights reserved.
//

import UIKit

class ProfileViewCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    
    class func cellId () -> String{
        return "profileViewCellId"
    }
    
}
