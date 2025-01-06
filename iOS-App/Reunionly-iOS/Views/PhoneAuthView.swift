//
//  PhoneAuthView.swift
//  Reunionly
//
//  Created by Terrence Pledger on 1/5/25.
//

import SwiftUI
import FirebaseAuth

struct PhoneAuthView: View {
    @State private var phoneNumber = ""
    @State private var verificationCode = ""
    @State private var verificationID: String?
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("Phone Number", text: $phoneNumber)
                .keyboardType(.phonePad)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
            
            Button("Send Code") {
                sendVerificationCode()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            
            TextField("Verification Code", text: $verificationCode)
                .keyboardType(.numberPad)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
            
            Button("Verify Code") {
                verifyCode()
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
    }
    
    func sendVerificationCode() {
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
            if let error = error {
                print("Error sending verification code: \(error)")
                return
            }
            
            self.verificationID = verificationID
            print("Verification code sent.")
        }
    }
    
    func verifyCode() {
        guard let verificationID = verificationID else { return }
        
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: verificationCode)
        
        Auth.auth().signIn(with: credential) { result, error in
            if let error = error {
                print("Error verifying code: \(error)")
            } else {
                print("Phone number verified and user signed in!")
            }
        }
    }
}
