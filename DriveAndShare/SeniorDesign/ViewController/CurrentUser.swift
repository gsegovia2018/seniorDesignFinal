//
//  CurrentUser.swift
//  SeniorDesign
//
//  Created by Guillermo Segovia Marcos on 9/24/20.
//  Copyright © 2020 Guillermo Segovia. All rights reserved.
//

import Foundation

struct CurrentUser {
    let uid: String
    let firstName: String
    let lastName: String
    let gender: String
    
    
    init(uid: String, dictionary: [String: Any]){
        self.uid = uid
        self.firstName = dictionary["firstName"] as? String ?? ""
        self.lastName = dictionary["lastName"] as? String ?? ""
        self.gender = dictionary["email"] as? String ?? ""
    }
}
