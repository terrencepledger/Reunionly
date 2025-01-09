//
//  SignInOptionsViewModel.swift
//  Reunionly
//
//  Created by Terrence Pledger on 1/8/25.
//

import SwiftUI
import GoogleSignIn
import FirebaseAuth
import FirebaseCore

class SignInOptionsViewModel: ObservableObject {
    func signInWithGoogle(presenting: Binding<Bool>) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            print("Unable to get root view controller.")
            return
        }
        
        GIDSignIn.sharedInstance.configure()
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            print("Unable to retrieve Firebase clientID")
            return
        }
        GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { user, error in
            if let error = error {
                print("Error signing in: \(error)")
                return
            }
            
            guard let idToken = user?.user.idToken?.tokenString,
                  let accessToken = user?.user.accessToken.tokenString else { return }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            
            Auth.auth().signIn(with: credential) { result, error in
                if let error = error {
                    print("Firebase sign-in error: \(error)")
                } else {
                    presenting.wrappedValue = false
                }
            }
        }
    }
}
