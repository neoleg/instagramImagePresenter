//
//  ServerManager.swift
//  presenter
//
//  Created by DeveloperMB on 8/1/18.
//  Copyright © 2018 DeveloperMB. All rights reserved.
//

import Foundation
import Alamofire

class ServerManager {
    static let sharedManager = ServerManager()
    var accessToken: String? = nil
    
    
    public func saveToUserDefaults () {
        
        if self.accessToken != nil {
            UserDefaults.standard.set(self.accessToken!, forKey: "accessToken")
        }
    }
    
    
    func authorize (witn code: String, completion: @escaping (_ result: String) -> Void) {
        
        let url = try! URLRequest(url: URL(string:"https://api.instagram.com/oauth/access_token")!, method: .post, headers: nil)
        
        let parametrs = ["client_id":"ca086be5d4ad458c8b51f7e114a68b46",
                         "client_secret":"1f3bae9afab946eba5e1f925532b9844",
                         "grant_type":"authorization_code",
                         "redirect_uri":"https://www.example.com",
                         "code":code]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in parametrs {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
            
        }, with: url) { (encodingResult) in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    if((response.result.value) != nil) {
                        if let json = response.result.value as? [String: Any] {
                            
                            self.accessToken = (json["access_token"]! as! String)
                            self.saveToUserDefaults()
                            completion(self.accessToken!)
                            
                        }
                    } else {
                        print("nil response")
                    }
                }
            case .failure(_):
                break
            }
        }
    }
    
    
    
    
    public func getUserData (completion: @escaping (_ result: Array<Any>) -> Void) {
        
        if self.accessToken != nil {
            Alamofire.request("https://api.instagram.com/v1/users/self/media/recent/?access_token=" + self.accessToken!).responseJSON { (response) in
                switch response.result{
                case .success(_):
                    print("success")
                    if let result = response.result.value {
                        let parsedJSON = self.parseResponse(response: result)
                        completion(parsedJSON)
                    }
                case .failure(_):
                    print("failure")
                }
            }
        }
    }
    
    
    
    public func parseResponse (response: Any) -> Array<Any> {
        
        var parsedArray = [] as Array
        
        let json = response as! [String: Any]
        let data = json["data"] as! [[String: Any]]
        
        for item in data {
            let images = item["images"] as! [String: Any]
            
            let thumbnail = images["thumbnail"] as! [String: Any]
            let thumbnailURL = thumbnail["url"] as! String
            
            let standardResolution = images["standard_resolution"] as! [String: Any]
            let standardResolutionURL = standardResolution["url"] as! String
            
            let dict = ["thumbnailURL": thumbnailURL, "standardResolutionURL": standardResolutionURL]
            
            parsedArray.append(dict)
        }
        
        let user = data[0]["user"] as! [String: Any]
        let username = user["username"] as! String
        let profilePicture = user["profile_picture"] as! String
        
        let infoDict = ["username": username, "profilePicture": profilePicture]
        
        parsedArray.append(infoDict)
        return parsedArray
        
    }
    
    
    
    
    
}
