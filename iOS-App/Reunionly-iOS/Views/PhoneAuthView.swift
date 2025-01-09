//
//  PhoneAuthView.swift
//  Reunionly
//
//  Created by Terrence Pledger on 1/5/25.
//

import SwiftUI
import FirebaseAuth

struct PhoneAuthView: View {
    @StateObject private var viewModel = PhoneAuthViewModel()
    @State var presenting: Binding<Bool>

    var body: some View {
        VStack(spacing: 20) {
            TextField("Phone Number", text: $viewModel.phoneNumber)
                .keyboardType(.phonePad)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
            
            Button("Send Code") {
                viewModel.sendVerificationCode()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            
            TextField("Verification Code", text: $viewModel.verificationCode)
                .keyboardType(.numberPad)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
            
            Button("Verify Code") {
                viewModel.verifyCode(presenting: presenting)
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(8)
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding(.top, 10)
            }
        }
        .padding()
    }
}

