//
//  EventDetailsScreen.swift
//  Reunionly
//
//  Created by Terrence Pledger on 1/4/25.
//

import SwiftUI
import FirebaseAuth

struct EventDetailsView: View {
    let event: Event
    @State private var isAuthenticated = false
    @State private var showSignInOptions = false

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
            
            if isAuthenticated {
                NavigationLink(destination: RSVPView(event: event)) {
                    Text("RSVP Now")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            } else {
                Button(action: {
                    showSignInOptions = true
                }) {
                    Text("Sign In to RSVP")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .sheet(isPresented: $showSignInOptions) {
                    SignInOptionsView()
                }
            }
        }
        .padding()
        .navigationTitle("Event Details")
        .onAppear {
            checkAuthStatus()
        }
    }

    func checkAuthStatus() {
        isAuthenticated = Auth.auth().currentUser != nil
    }
}
