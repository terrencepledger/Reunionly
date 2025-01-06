//
//  SignInOptionsView.swift
//  Reunionly
//
//  Created by Terrence Pledger on 1/6/25.
//


import SwiftUI
import FirebaseCore
import GoogleSignIn
import FirebaseAuth


struct SignInOptionsView: View {
    @State private var showPhoneAuthView = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Sign In to Continue")
                .font(.largeTitle)
                .bold()
            
            Button(action: handleGoogleSignIn) {
                HStack {
                    Image(systemName: "globe")
                    Text("Sign in with Google")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            
            Button {
                showPhoneAuthView = true
            } label: {
                HStack {
                    Image(systemName: "phone")
                    Text("Sign in with Phone Number")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            
            Spacer()
        }
        .sheet(isPresented: $showPhoneAuthView) {
            PhoneAuthView()
        }
        .padding()
    }

    func handleGoogleSignIn() {
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
            
            guard let idToken = user?.user.idToken?.tokenString, let accessToken = user?.user.accessToken.tokenString else { return }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            
            Auth.auth().signIn(with: credential) { result, error in
                if let error = error {
                    print("Firebase sign-in error: \(error)")
                } else {
                    print("User signed in with Google!")
                }
            }
        }
    }
}
