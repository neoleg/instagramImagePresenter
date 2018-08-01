//
//  ProfileViewController.swift
//  instagramImagePresenter
//
//  Created by DeveloperMB on 7/31/18.
//  Copyright © 2018 DeveloperMB. All rights reserved.
//

import UIKit
import SDWebImage


class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profileIcon: UIImageView!
    
    var profileData = DataManager.sharedManager.userData
    var lastTap: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        self.userNameLabel.text = (self.profileData.last as! NSDictionary).object(forKey: "username") as? String
        
        let currentImage = (self.profileData.last as! NSDictionary).object(forKey: "profilePicture") as? String
        self.profileIcon.sd_setImage(with: URL(string: currentImage!), placeholderImage: UIImage(named: "placeholder.png"))
        
        self.collectionView.reloadData()

        
    }
    
    
    // MARK: - collectionView
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        print(self.profileData.count)
        return self.profileData.count - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileViewCell.cellId(), for: indexPath) as! ProfileViewCell

        //add gesture recognizer
        
        cell.image.isUserInteractionEnabled = true
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressHandler(sender:)))
        cell.image.addGestureRecognizer(longPress)
        
        //setup image
        
        let currentImage = (self.profileData[indexPath.row] as! NSDictionary).object(forKey: "thumbnailURL") as? String
        cell.image.sd_setImage(with: URL(string: currentImage!), placeholderImage: UIImage(named: "placeholder.png"))
        cell.image.tag = indexPath.row
        
        return cell
    }
    
    
    // MARK: - gestureRecognizer
    
    
    @objc func longPressHandler(sender: UILongPressGestureRecognizer) {
        
        if sender.state == UIGestureRecognizerState.began {
            
            self.lastTap = (sender.view?.tag)!
            performSegue(withIdentifier: "profileToFullscreen", sender: sender)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let imageFullscreen: FullscreenImageViewController = segue.destination as! FullscreenImageViewController
        
        let currentImage = (self.profileData[self.lastTap] as! NSDictionary).object(forKey: "standardResolutionURL") as? String
        imageFullscreen.imageURL = currentImage
        
    }
    
    
}



