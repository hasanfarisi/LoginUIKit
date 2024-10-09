//
//  ErrorResponse.swift
//  LoginUIKit
//
//  Created by mac on 10/9/24.
//

import Foundation

struct ErrorResponse:Codable,Identifiable{
    let id: String = UUID().uuidString
    var name:String = ""
    var code:String = ""
    //var message:String = ""
//    var description:String = ""
    //var policy:String = ""
    var statusCode:Int = 400
    //var error:String = ""
}
