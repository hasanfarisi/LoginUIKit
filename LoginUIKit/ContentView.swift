//
//  ContentView.swift
//  LoginUIKit
//
//  Created by mac on 10/8/24.
//

import SwiftUI

struct ContentView: View {
    // View properties
    @State private var showSignup: Bool = false
    // keyboard state
    @State private var isKeyboardShowing: Bool = false
    var body: some View {
        NavigationStack {
            Login(showSignup: $showSignup)
                .navigationDestination(isPresented: $showSignup){
                    Signup(showSignup: $showSignup)
                }
            // checkin if any keyboard is visible
                .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification), perform: { _ in if !showSignup{ isKeyboardShowing = false }
                })
                .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification), perform: { _ in isKeyboardShowing = false
                })
        }
        .overlay{
            // iOS 17 Bounce animation
            if #available(iOS 17, *){
                //since this project supports iOS 16 too
                CircleView()
                    .animation(.smooth(duration: 0.45, extraBounce: 0), value: showSignup)
                    .animation(.smooth(duration: 0.45, extraBounce: 0), value: isKeyboardShowing)
            }else{
                CircleView()
                    .animation(.easeInOut(duration: 0.3), value: showSignup)
                    .animation(.easeInOut(duration: 0.3), value: isKeyboardShowing)
            }
        }
    }
    
    // moving blurred background
    @ViewBuilder
    func CircleView() -> some View {
        Circle()
            .fill(.linearGradient(colors: [.orange, .red], startPoint: .top, endPoint: .bottom))
            .frame(width: 200, height:  200)
        // Moving when the sign up pages load/dismisses
            .offset(x: showSignup ? 90 : -90, y: -90 - (isKeyboardShowing ? 200 : 0))
            .blur(radius: 15)
            .hSpacing(showSignup ? .trailing : .leading)
            .vSpacing(.top)
    }
}

#Preview {
    ContentView()
}
