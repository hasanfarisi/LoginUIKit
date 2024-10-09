//
//  LoginUIKitApp.swift
//  LoginUIKit
//
//  Created by mac on 10/8/24.
//

import SwiftUI

@main
struct LoginUIKitApp: App {
    @StateObject private var authUser = AuthUser()
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(authUser)
        }
    }
}
