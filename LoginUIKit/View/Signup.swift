//
//  Signup.swift
//  LoginUIKit
//
//  Created by mac on 10/8/24.
//

import SwiftUI

struct Signup: View {
    @Binding var showSignup:Bool
    @State private var emailID:String = ""
    @State private var fullName:String = ""
    @State private var password:String = ""
    @State private var otpText:String = ""
    @EnvironmentObject var userAuth: AuthUser
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15, content: {
            // Back button
            Button(action: {
                showSignup = false
            }, label: {
                Image(systemName: "arrow.left")
                    .font(.title2)
                    .foregroundStyle(.gray)
            })
            .padding(.top, 10)
            Text("Singup")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .padding(.top, 25)
            
            Text("Please sign up to continue")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.gray)
                .padding(.top, -5)
            
            VStack(spacing: 25){
                // Custom text fields
                CustomTF(sfIcon: "at", hint: "Email ID",isEmail: true, value: $emailID)
                
                CustomTF(sfIcon: "person", hint: "Username", value: $fullName)
                    .padding(.top, 5)
                
                CustomTF(sfIcon: "lock", hint: "Password",isPassword: true, value: $password)
                    .padding(.top, 5)
                
                if !userAuth.isCorrect {
                    Text(userAuth.isError).foregroundColor(.red)
                }
                
                // Singup button
                GradientButton(title: "Continue", icon: "arrow.right"){
                    /// your code
                    self.userAuth.checkRegister(username: fullName, password: password, email: emailID)
                }
                .hSpacing(.trailing)
                //Disabling until the data is entered
                .disableWithOpacity(emailID.isEmpty || password.isEmpty || fullName.isEmpty)
            }
            .padding(.top, 20)
            
            Spacer(minLength: 0)
            HStack(spacing: 6){
                Text("Already have an account?")
                    .foregroundStyle(.gray)
                Button("Login"){
                    showSignup = false
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
        
        // OTP Prompt
        .sheet(isPresented: $userAuth.needVerified, content: {
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
