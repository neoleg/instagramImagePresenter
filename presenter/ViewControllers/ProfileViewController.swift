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
    
    private var userPhotos = [] as Array
    private var userPersonal: ServerManager.userPersonalType? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let accessToken = UserDefaults.standard.string(forKey: "accessToken") {
            
            MBProgressHUD.showAdded(to: self.view, animated: true)
            ServerManager.sharedManager.accessToken = accessToken
            
            ServerManager.sharedManager.getUserData { (userPhotos, userPersonal, error) in
                if error == nil {
                    self.userPhotos = userPhotos!
                    self.userPersonal = userPersonal!
                    DispatchQueue.main.async {
                        self.setupData()
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }
                } else {
                    print(error!)
                }
            }
        } else {
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
                self.performSegue(withIdentifier: "profileToAuthorization", sender: nil)
            }
        }
    }

    private func setupData() {
        
        self.username.text = self.userPersonal?.username
        let currentImage = self.userPersonal?.profilePicture
        self.profileIcon.sd_setImage(with: URL(string: currentImage!), completed: nil)
       
        photoCollection.reloadData()
    }
    
    // MARK: - gesture handler
    
    
    @objc func longPressHandler(sender: UILongPressGestureRecognizer) {
        
        if sender.state == UIGestureRecognizerState.began {
            
            if let gestureView = sender.view, let info = self.userPhotos[gestureView.tag] as? ServerManager.userPhotosType {
                let currentImage = info.standardResolutionURL
                performSegue(withIdentifier: "profileToFullscreen", sender: currentImage)
            }
        }
    }
    
    // MARK: - collection view
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.userPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = photoCollection.dequeueReusableCell(withReuseIdentifier: PhotoCollectionCell.cellId(), for: indexPath) as! PhotoCollectionCell
        
        //add gesture recognizer
        
        if let gesture = cell.image.gestureRecognizers?.last {
            cell.image.removeGestureRecognizer(gesture)
        }
        cell.image.isUserInteractionEnabled = true
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressHandler(sender:)))
        cell.image.addGestureRecognizer(longPress)
        
        //setup image
        
        if let info = self.userPhotos[indexPath.row] as? ServerManager.userPhotosType {
            let currentImage = info.thumbnailURL
            cell.image.sd_setImage(with: URL(string: currentImage), completed: nil)
        } else {
            cell.image.image = nil
        }
        cell.image.tag = indexPath.row
        
        return cell
    }
    
    // MARK: - segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "profileToFullscreen" {
            
            let fullscreenView: FullscreenImageViewController = segue.destination as! FullscreenImageViewController
            
            fullscreenView.imageURL = sender as? String
            
        }
    }

}

