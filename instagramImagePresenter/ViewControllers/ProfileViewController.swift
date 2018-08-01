//
//  ProfileViewController.swift
//  instagramImagePresenter
//
//  Created by DeveloperMB on 7/31/18.
//  Copyright © 2018 DeveloperMB. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profileIcon: UIImageView!
    
    var profileData = [] as Array
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        AuthorizationManager.sharedManager.getUserData { (response) in
            self.profileData = response
            
            
            
            self.collectionView.reloadData()
        }
        
    }
    
    
    // MARK: - collectionView
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return self.profileData.count - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileViewCell.cellId(), for: indexPath) as! ProfileViewCell

        
        
        return cell
    }
}



