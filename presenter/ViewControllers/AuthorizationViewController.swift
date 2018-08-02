//
//  AuthorizationViewController.swift
//  presenter
//
//  Created by DeveloperMB on 8/1/18.
//  Copyright © 2018 DeveloperMB. All rights reserved.
//

import UIKit
import WebKit
import MBProgressHUD

class AuthorizationViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //self.addConstraints(to: self.webView, with: self.view)
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let authURL = String("https://api.instagram.com/oauth/authorize/?client_id=ca086be5d4ad458c8b51f7e114a68b46&redirect_uri=https://www.example.com&response_type=code");
        let urlRequest = URLRequest.init(url: URL.init(string: authURL)!)
        self.webView.navigationDelegate = self
        self.webView.load(urlRequest)
        MBProgressHUD.showAdded(to: self.webView, animated: true)
        
    }
    
    
    public func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        
        let urlString = webView.url!.absoluteString;
        
        if urlString.contains("https://www.example.com/?code=") {
            let code = urlString.components(separatedBy: "=").last!
            ServerManager.sharedManager.authorize(witn: code) { (accessToken) in
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        MBProgressHUD.hide(for: webView, animated: true)
    }
    
    
    func addConstraints(to webView: UIView, with superView: UIView) {
        webView.translatesAutoresizingMaskIntoConstraints = false
        let leadingConstraint = NSLayoutConstraint(item: webView, attribute: .leading, relatedBy: .equal, toItem: superView, attribute: .leading, multiplier: 1, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: webView, attribute: .trailing, relatedBy: .equal, toItem: superView, attribute: .trailing, multiplier: 1, constant: 0)
        let topConstraint = NSLayoutConstraint(item: webView, attribute: .top, relatedBy: .equal, toItem: superView, attribute: .top, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: webView, attribute: .bottom, relatedBy: .equal, toItem: superView, attribute: .bottom, multiplier: 1, constant: 0)
        superView.addConstraints([leadingConstraint, trailingConstraint, topConstraint, bottomConstraint])
    }
    
}
