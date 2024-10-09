//
//  OTPView.swift
//  LoginUIKit
//
//  Created by mac on 10/8/24.
//

import SwiftUI

struct OTPView: View {
    @Binding var otpText:String
    // environment properties
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        VStack(alignment: .leading, spacing: 15, content: {
            // Back button
//            Button(action: {
//                dismiss()
//            }, label: {
//                Image(systemName: "arrow.left")
//                    .font(.title2)
//                    .foregroundStyle(.gray)
//            })
//            .padding(.top, 15)
            Text("Signup successfull, please check your Email").foregroundColor(.green)
            Text("Enter OTP")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .padding(.top, 5)
            
            Text("An 6 digit code has been sent to your email ID")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.gray)
                .padding(.top, -5)
            
            VStack(spacing: 25){
                // custom OTP textfield
                OTPVerificationView(otpText: $otpText)
                // Singup button
                GradientButton(title: "Send", icon: "arrow.right"){
                    // modified code
                }
                .hSpacing(.trailing)
                //Disabling until the data is entered
                .disableWithOpacity(otpText.isEmpty)
            }
            .padding(.top, 20)
            
            Spacer(minLength: 10)
        })
        .padding(.vertical, 15)
        .padding(.horizontal, 25)
        // since this is going to be a sheet.
        .interactiveDismissDisabled()
    }
}
