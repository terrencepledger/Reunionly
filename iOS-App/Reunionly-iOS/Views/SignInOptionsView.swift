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
    @State var presenting: Binding<Bool>
    @State private var showPhoneAuthView = false
    @StateObject private var viewModel = SignInOptionsViewModel()

    var body: some View {
        VStack(spacing: 20) {
            Text("Sign In to Continue")
                .font(.largeTitle)
                .bold()
            
            Button(action: {
                viewModel.signInWithGoogle(presenting: presenting)
            }) {
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
            PhoneAuthView(presenting: $showPhoneAuthView)
                .onDisappear {
                    presenting.wrappedValue = false
                }
        }
        .padding()
    }
}
