//
//  PhoneAuthViewModel.swift
//  Reunionly
//
//  Created by Terrence Pledger on 1/8/25.
//

import Foundation
import FirebaseAuth
import SwiftUI

class PhoneAuthViewModel: ObservableObject {
    @Published var phoneNumber = ""
    @Published var verificationCode = ""
    @Published var verificationID: String?
    @Published var errorMessage: String?

    func sendVerificationCode() {
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { [weak self] verificationID, error in
            if let error = error {
                self?.errorMessage = "Error sending verification code: \(error.localizedDescription)"
                return
            }
            
            self?.verificationID = verificationID
            self?.errorMessage = "Verification code sent."
        }
    }
    
    func verifyCode(presenting: Binding<Bool>) {
        guard let verificationID = verificationID else {
            errorMessage = "Verification ID is missing."
            return
        }

        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: verificationCode)

        Auth.auth().signIn(with: credential) { [weak self] result, error in
            if let error = error {
                self?.errorMessage = "Error verifying code: \(error.localizedDescription)"
            } else {
                presenting.wrappedValue = false
                self?.errorMessage = nil
            }
        }
    }
}
