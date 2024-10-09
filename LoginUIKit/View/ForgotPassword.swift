//
//  ForgotPassword.swift
//  LoginUIKit
//
//  Created by mac on 10/8/24.
//

import SwiftUI

struct ForgotPassword: View {
    @Binding var showResetView:Bool
    @State private var emailID:String = ""
    // environment properties
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        VStack(alignment: .leading, spacing: 15, content: {
            // Back button
            Button(action: {
                dismiss()
            }, label: {
                Image(systemName: "arrow.left")
                    .font(.title2)
                    .foregroundStyle(.gray)
            })
            .padding(.top, 10)
            Text("Forgot Password")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .padding(.top, 5)
            
            Text("Please enter your email ID so that we can send the reset link.")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.gray)
                .padding(.top, -5)
            
            VStack(spacing: 25){
                // Custom text fields
                CustomTF(sfIcon: "at", hint: "Email ID", value: $emailID)
                
                // Singup button
                GradientButton(title: "Send link", icon: "arrow.right"){
                    // modified code
                    Task {
                        dismiss()
                        try? await Task.sleep(for: .seconds(0))
                        // showing the reset view
                        showResetView = true
                    }
                }
                .hSpacing(.trailing)
                //Disabling until the data is entered
                .disableWithOpacity(emailID.isEmpty)
            }
            .padding(.top, 20)
        })
        .padding(.vertical, 15)
        .padding(.horizontal, 25)
        // since this is going to be a sheet.
        .interactiveDismissDisabled()
    }
}
