//
//  PasswordResetView.swift
//  LoginUIKit
//
//  Created by mac on 10/8/24.
//

import SwiftUI

struct PasswordResetView: View {
    @State private var password:String = ""
    @State private var confirmPassword:String = ""
    // environment properties
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        VStack(alignment: .leading, spacing: 15, content: {
            // Back button
            Button(action: {
                dismiss()
            }, label: {
                Image(systemName: "xmark")
                    .font(.title2)
                    .foregroundStyle(.gray)
            })
            .padding(.top, 10)
            Text("Reset Password?")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .padding(.top, 5)
            
            VStack(spacing: 25){
                // Custom text fields
                CustomTF(sfIcon: "lock", hint: "Password", value: $password)
                
                CustomTF(sfIcon: "lock", hint: "Confirm Password", value: $confirmPassword)
                    .padding(.top, 5)
                
                // Singup button
                GradientButton(title: "Save", icon: "arrow.right"){
                    // modified code
                    // reset password
                }
                .hSpacing(.trailing)
                //Disabling until the data is entered
                .disableWithOpacity(password.isEmpty || confirmPassword.isEmpty)
            }
            .padding(.top, 20)
        })
        .padding(.vertical, 15)
        .padding(.horizontal, 25)
        // since this is going to be a sheet.
        .interactiveDismissDisabled()
    }
}

#Preview {
    ContentView()
}
