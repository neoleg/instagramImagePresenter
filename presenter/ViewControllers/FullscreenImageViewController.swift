//
//  FullscreenImageViewController.swift
//  instagramImagePresenter
//
//  Created by DeveloperMB on 8/1/18.
//  Copyright © 2018 DeveloperMB. All rights reserved.
//

import UIKit

class FullscreenImageViewController: UIViewController {
    
    enum Contstants {
        static let viewCornerRadius: CGFloat = 15
    }
    
    var imageURL: String? = nil
    
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.roundCorners(view: self.footerView, corners: "buttom", radius: Contstants.viewCornerRadius)
        self.roundCorners(view: self.imageView, corners: "top", radius: Contstants.viewCornerRadius)
        
        self.imageView.sd_setImage(with: URL(string: self.imageURL!), completed: nil)
        
    }
    
    // MARK: - Private
    
    private func roundCorners (view: UIView, corners: String, radius: CGFloat) {
        
        view.clipsToBounds = true
        view.layer.cornerRadius = radius
        
        switch corners {
        case "top":
            view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        case "buttom":
            view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        case "left":
            view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        case "right":
            view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        case "all":
            view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        default:
            break
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func tapHandler(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func hideButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
