//
//  Token.swift
//  LoginUIKit
//
//  Created by mac on 10/10/24.
//

import Foundation

struct Token:Codable,Identifiable{
    let id: String = UUID().uuidString
    var access_token:String
    var id_token:String
    var scope:String
    var expires_in:Int
    var token_type:String
}
