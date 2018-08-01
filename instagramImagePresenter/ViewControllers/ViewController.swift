//
//  ViewController.swift
//  instagramImagePresenter
//
//  Created by DeveloperMB on 7/31/18.
//  Copyright © 2018 DeveloperMB. All rights reserved.
//

import UIKit
import WebKit
import Alamofire

class ViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let authURL = String("https://api.instagram.com/oauth/authorize/?client_id=ca086be5d4ad458c8b51f7e114a68b46&redirect_uri=https://www.example.com&response_type=code");
        
        let urlRequest = URLRequest.init(url: URL.init(string: authURL)!)
        
        webView.navigationDelegate = self
        webView.load(urlRequest)
    }
    
    
    
    public func contatainsAuthorizationCode(url: URL) -> Bool {
        
        let urlString = url.absoluteString;
        if urlString.contains("https://www.example.com/?code=") {
            
            return true
        }
        
        return false
    }
    
    
}

extension ViewController: WKNavigationDelegate {
    
    public func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        
        if contatainsAuthorizationCode(url: webView.url!) {
            
            print("contains")
            
            let urlString = webView.url!.absoluteString;
            let code = urlString.components(separatedBy: "=")
            
            AuthorizationManager.sharedManager.getAccessToken(authorizationCode: code.last!) { (accessToken) in
                
                print(accessToken)
                
                DataManager.sharedManager.loadData(completion: {
                    
                    let userProfileView = self.storyboard?.instantiateViewController(withIdentifier: "profileViewController")
                    self.present(userProfileView!, animated: true, completion: nil)
                    
                })
                
            }
            
        }
    }
}

