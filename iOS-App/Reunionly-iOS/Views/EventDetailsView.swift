//
//  EventDetailsScreen.swift
//  Reunionly
//
//  Created by Terrence Pledger on 1/4/25.
//

import SwiftUI
import GoogleSignIn
import FirebaseAuth
import FirebaseCore

struct EventDetailsView: View {
    let event: Event
    @State private var showPhoneAuthView = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(event.name)
                .font(.largeTitle)
                .bold()
            
            Text(event.description)
                .font(.title2)
                .italic()
            
            HStack {
                Text(event.eventDate, style: .date)
                    .font(.title2)
                
                Text(event.eventDate, style: .time)
                    .font(.title2)
            }
            
            Text("Location: \(event.location)")
                .font(.title3)
            
            Spacer()
            
            // Google Sign-In Button
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
            
            // Phone Auth Button
            Button(action: {
                showPhoneAuthView = true
            }) {
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
            .sheet(isPresented: $showPhoneAuthView) {
                PhoneAuthView()
            }
        }
        .padding()
        .navigationTitle("Event Details")
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

