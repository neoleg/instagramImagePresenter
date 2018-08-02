//
//  ViewController.swift
//  presenter
//
//  Created by DeveloperMB on 8/1/18.
//  Copyright © 2018 DeveloperMB. All rights reserved.
//

import UIKit
import SDWebImage
import MBProgressHUD

class ProfileViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var photoCollection: UICollectionView!
    @IBOutlet weak var profileIcon: UIImageView!
    @IBOutlet weak var username: UILabel!
    
    var userData = [] as Array
    var lastTappedImage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if let accessToken = UserDefaults.standard.string(forKey: "accessToken") {
            
            MBProgressHUD.showAdded(to: self.view, animated: true)
            ServerManager.sharedManager.accessToken = accessToken
            
            ServerManager.sharedManager.getUserData { (response) in
                self.userData = response
                DispatchQueue.main.async {
                    self.setupData()
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                }
            }
            
        } else {
            
            performSegue(withIdentifier: "profileToAuthorization", sender: self)
            
        }
    }
    

    func setupData() {
        
        self.username.text = (self.userData.last as! NSDictionary).object(forKey: "username") as? String
        let currentImage = (self.userData.last as! NSDictionary).object(forKey: "profilePicture") as? String
        self.profileIcon.sd_setImage(with: URL(string: currentImage!), completed: nil)
        photoCollection.reloadData()
        
    }
    
    
    // MARK: - segue
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "profileToAuthorization" {
            let _: AuthorizationViewController = segue.destination as! AuthorizationViewController
        }
        
        if segue.identifier == "profileToFullscreen" {
            
            let fullscreenView: FullscreenImageViewController = segue.destination as! FullscreenImageViewController
            
            let currentImage = (self.userData[self.lastTappedImage] as! NSDictionary).object(forKey: "standardResolutionURL") as? String
            fullscreenView.imageURL = currentImage
            
        }
    }
    
    
    // MARK: - collection view
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.userData.count - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = photoCollection.dequeueReusableCell(withReuseIdentifier: PhotoCollectionCell.cellId(), for: indexPath) as! PhotoCollectionCell
        
        //add gesture recognizer
        
        cell.image.isUserInteractionEnabled = true
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressHandler(sender:)))
        cell.image.addGestureRecognizer(longPress)
        
        //setup image
        
        let currentImage = (self.userData[indexPath.row] as! NSDictionary).object(forKey: "thumbnailURL") as? String
        cell.image.sd_setImage(with: URL(string: currentImage!), completed: nil)
        cell.image.tag = indexPath.row
        
        return cell
        
    }
    
    
    // MARK: - gesture handler
    
    
    @objc func longPressHandler(sender: UILongPressGestureRecognizer) {
        
        if sender.state == UIGestureRecognizerState.began {
            
            self.lastTappedImage = (sender.view?.tag)!
            performSegue(withIdentifier: "profileToFullscreen", sender: sender)
            
        }
    }
    

}

