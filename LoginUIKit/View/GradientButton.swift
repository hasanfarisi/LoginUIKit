//
//  GradientButton.swift
//  LoginUIKit
//
//  Created by mac on 10/8/24.
//

import SwiftUI

struct GradientButton: View {
    var title: String
    var icon: String
    var onClick: () -> ()
    var body: some View {
        Button(action: onClick, label: {
            HStack(spacing: 15) {
                Text(title)
                Image(systemName: icon)
            }
            .fontWeight(.bold)
            .padding(.vertical, 12)
            .padding(.horizontal, 35)
            .foregroundColor(Color.white)
            .background(.linearGradient(colors: [.green, .yellow], startPoint: .top, endPoint: .bottom), in: .capsule)
        })
    }
}
