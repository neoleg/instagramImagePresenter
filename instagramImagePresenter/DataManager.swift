//
//  DataManager.swift
//  instagramImagePresenter
//
//  Created by DeveloperMB on 8/1/18.
//  Copyright © 2018 DeveloperMB. All rights reserved.
//

import Foundation

class DataManager {
    static let sharedManager = DataManager()
    var userData = [] as Array
    
    
    public func loadData (completion: @escaping () -> Void) {
        AuthorizationManager.sharedManager.getUserData { (response) in
            self.userData = response
            completion()
        }
    }

    
}
