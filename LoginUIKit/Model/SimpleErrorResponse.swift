//
//  SimpleErrorResponse.swift
//  LoginUIKit
//
//  Created by mac on 10/10/24.
//

import Foundation

struct SimpleErrorResponse:Codable,Identifiable{
    let id: String = UUID().uuidString
    var error:String = ""
    //var error_description:String = ""
}
