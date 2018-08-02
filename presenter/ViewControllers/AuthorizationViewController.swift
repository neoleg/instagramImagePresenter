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
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let authURL = String(ServerManager.Constants.baseUrl + "oauth/authorize/?client_id=" + ServerManager.Constants.clientId + "&redirect_uri=" + ServerManager.Constants.redirectUri + "&response_type=" + ServerManager.Constants.responseType);
        
        let urlRequest = URLRequest.init(url: URL.init(string: authURL)!)
        self.webView.navigationDelegate = self
        self.webView.load(urlRequest)
        MBProgressHUD.showAdded(to: self.webView, animated: true)
        
    }
    
    // MARK: - WKNavigationDelegate
    
    public func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        
        let urlString = webView.url!.absoluteString;
        
        if urlString.contains(ServerManager.Constants.redirectUri + "/?" + ServerManager.Constants.responseType + ServerManager.Constants.urlSeparator) {
            let code = urlString.components(separatedBy: ServerManager.Constants.urlSeparator).last!
            ServerManager.sharedManager.authorize(witn: code) { (accessToken, error) in
                
                if accessToken != nil {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    print (error!.domain)
                    self.dismiss(animated: true, completion: nil)
                }
            }
        } 
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        MBProgressHUD.hide(for: webView, animated: true)
    }
}
