//
//  User.swift
//  LoginUIKit
//
//  Created by mac on 10/9/24.
//

import Foundation

struct User:Codable,Identifiable{
    let id: String = UUID().uuidString
    var _id:String
    var username:String
    var email:String
    var email_verified:Bool = false    
}
