//
//  User.swift
//  LoginUIKit
//
//  Created by mac on 10/9/24.
//

import Foundation

struct User:Codable,Identifiable{
    let id = UUID().uuidString
    var sub:String
    var nickname:String
    var name:String
    var picture:String
    var updated_at:String
    var email:String
    var email_verified:String
}
