//
//  Login.swift
//  LoginUIKit
//
//  Created by mac on 10/8/24.
//

import SwiftUI

struct Login: View {
    @Binding var showSignup:Bool
    @State private var emailID:String = ""
    @State private var password:String = ""
    @State private var showForgotPasswordView:Bool = false
    @State private var showResetView:Bool = false
    @State private var askOTP:Bool = false
    @State private var otpText:String = ""
    var body: some View {
        VStack(alignment: .leading, spacing: 15, content: {
            Spacer(minLength: 0)
            Text("Login")
                .font(.largeTitle)
                .fontWeight(.heavy)
            
            Text("Please sign in to continue")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.gray)
                .padding(.top, -5)
            
            VStack(spacing: 25){
                // Custom text fields
                CustomTF(sfIcon: "at", hint: "Email ID", value: $emailID)
                
                CustomTF(sfIcon: "lock", hint: "Password",isPassword: true, value: $password)
                    .padding(.top, 5)
                
                Button("Forgot password"){
                    showForgotPasswordView.toggle()
                }
                .font(.callout)
                .fontWeight(.heavy)
                .tint(.orange)
                .hSpacing(.trailing)
                
                // login button
                GradientButton(title: "Login", icon: "arrow.right"){
                    /// your code
                    askOTP.toggle()
                }
                .hSpacing(.trailing)
                //Disabling until the data is entered
                .disableWithOpacity(emailID.isEmpty || password.isEmpty)
            }
            .padding(.top, 20)
            
            Spacer(minLength: 0)
            HStack(spacing: 6){
                Text("Don't have an account?")
                    .foregroundStyle(.gray)
                Button("Signup"){
                    showSignup.toggle()
                }
                .fontWeight(.bold)
                .tint(.orange)
            }
            .font(.callout)
            .hSpacing()
        })
        .padding(.vertical, 15)
        .padding(.horizontal, 25)
        .toolbar(.hidden, for: .navigationBar)
        // asking email id for sending reset link
        .sheet(isPresented: $showForgotPasswordView, content: {
            if #available(iOS 16.4, *){
                ForgotPassword(showResetView: $showResetView)
                    .presentationDetents([.height(300)])
                    .presentationCornerRadius(30)
            }else{
                ForgotPassword(showResetView: $showResetView)
                    .presentationDetents([.height(300)])
            }
        })
        // resetting new password
        .sheet(isPresented: $showResetView, content: {
            if #available(iOS 16.4, *){
                PasswordResetView()
                    .presentationDetents([.height(350)])
                    .presentationCornerRadius(30)
            }else{
                PasswordResetView()
                    .presentationDetents([.height(350)])
            }
        })
        // OTP Prompt
        .sheet(isPresented: $askOTP, content: {
            if #available(iOS 16.4, *){
                OTPView(otpText: $otpText)
                    .presentationDetents([.height(350)])
                    .presentationCornerRadius(30)
            }else{
                OTPView(otpText: $otpText)
                    .presentationDetents([.height(350)])
            }
        })
    }
}

#Preview {
    ContentView()
}
