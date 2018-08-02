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
    
    enum Constants {
        static let clientId = "ca086be5d4ad458c8b51f7e114a68b46"
        static let clientSecret = "1f3bae9afab946eba5e1f925532b9844"
        static let redirectUri = "https://www.example.com"
        static let responseType = "code"
        static let urlSeparator = "="
        static let baseUrl = "https://api.instagram.com/"
    }
    
    struct UserPersonal {
        let username: String
        let profilePicture: String
    }
    
    struct UserPhotos {
        let thumbnailURL: String
        let standardResolutionURL: String
    }
    
    static let sharedManager = ServerManager()
    
    var accessToken: String? = nil
    
    public func saveToUserDefaults () {
        
        if self.accessToken != nil {
            UserDefaults.standard.set(self.accessToken!, forKey: "accessToken")
        }
    }
    
    func authorize (witn code: String, completion: @escaping (_ result: String?, _ error: NSError?) -> Void) {
        
        let url = try! URLRequest(url: URL(string:Constants.baseUrl + "oauth/access_token")!, method: .post, headers: nil)
        
        let parametrs = ["client_id":Constants.clientId,
                         "client_secret":Constants.clientSecret,
                         "grant_type":"authorization_code",
                         "redirect_uri":Constants.redirectUri,
                         "code":code]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in parametrs {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
            
        }, with: url) { (encodingResult) in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    var parseError = true
                    if((response.result.value) != nil) {
                        if let json = response.result.value as? [String: Any] {
                            parseError = false
                            self.accessToken = (json["access_token"]! as! String)
                            self.saveToUserDefaults()
                            completion(self.accessToken, nil)
                            return
                        }
                    }
                    if parseError {
                        let parseError: NSError = NSError(domain: "parse error", code: 500, userInfo: nil)
                        completion(nil, parseError)
                    }
                }
            case .failure(_):
                let authorizationError: NSError = NSError(domain: "authorization error", code: 500, userInfo: nil)
                completion(nil, authorizationError)
                break
            }
        }
    }
    
    public func getUserData (completion: @escaping (_ userPhoto: Array<UserPhotos>?, _ userPersonal: UserPersonal?, _ error: NSError?) -> Void) {
        
        if self.accessToken != nil {
            Alamofire.request(Constants.baseUrl + "v1/users/self/media/recent/?access_token=" + self.accessToken!).responseJSON { (response) in
                switch response.result{
                case .success(_):
                    print("success")
                    var parseError = true
                    if let result = response.result.value {
                        let parsedPhotos = ServerManager.parsePhotos(response: result)
                        if let parsedPersonal = ServerManager.parsePersonal(response: result) {
                            parseError = false
                            completion(parsedPhotos, parsedPersonal, nil)
                        }
                    }
                    if parseError {
                        let parseError: NSError = NSError(domain: "parse error", code: 500, userInfo: nil)
                        completion(nil, nil, parseError)
                    }
                case .failure(_):
                    let parseError: NSError = NSError(domain: "authorization error", code: 500, userInfo: nil)
                    completion(nil, nil, parseError)
                }
            }
        }
    }
    
    class private func parsePhotos (response: Any) -> Array<UserPhotos>? {
        var parsedArray = [] as Array
        
        if let json = response as? [String: Any], let data = json["data"] as? [[String: Any]] {
            
            for item in data {
                
                if let images = item["images"] as? [String: Any], let thumbnail = images["thumbnail"] as? [String: Any], let thumbnailURL = thumbnail["url"] as? String, let standardResolution = images["standard_resolution"] as? [String: Any], let standardResolutionURL = standardResolution["url"] as? String  {
                    
                    let result: UserPhotos = UserPhotos(thumbnailURL: thumbnailURL, standardResolutionURL: standardResolutionURL)
                    parsedArray.append(result)
                }
            }
            return parsedArray as? Array<UserPhotos>
        }
        return nil
    }
    
    class private func parsePersonal (response: Any) -> UserPersonal? {
        
        if let json = response as? [String: Any], let data = json["data"] as? [[String: Any]], let user = data[0]["user"] as? [String: Any], let username = user["username"] as? String, let profilePicture = user["profile_picture"] as? String {
        
            let result: UserPersonal = UserPersonal(username: username, profilePicture: profilePicture)
            return result
        }
        return nil
    }

}
