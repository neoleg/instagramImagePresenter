//
//  FullscreenImageViewController.swift
//  instagramImagePresenter
//
//  Created by DeveloperMB on 8/1/18.
//  Copyright © 2018 DeveloperMB. All rights reserved.
//

import UIKit

class FullscreenImageViewController: UIViewController {
    
    var imageURL: String? = nil
    
    
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func tapHandler(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func hideButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.roundCorners(view: self.footerView, corners: "buttom", radius: 15)
        self.roundCorners(view: self.imageView, corners: "top", radius: 15)

        self.imageView.sd_setImage(with: URL(string: self.imageURL!)) { (image, error, cacheType, url) in
            self.activityIndicator.isHidden = true
        }
 
        
        
        
    }
    
    func roundCorners (view: UIView, corners: String, radius: Float) {
        
        view.clipsToBounds = true
        view.layer.cornerRadius = CGFloat(radius)
        
        switch corners {
        case "top":
            view.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        case "buttom":
            view.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        case "left":
            view.layer.maskedCorners = [.layerMinXMinYCorner,.layerMinXMaxYCorner]
        case "right":
            view.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMaxXMaxYCorner]
        case "all":
            view.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMaxXMaxYCorner]
        default:
            break
        }
    }
}
