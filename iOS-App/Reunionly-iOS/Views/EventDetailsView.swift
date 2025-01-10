//
//  EventDetailsView.swift
//  Reunionly
//
//  Created by Terrence Pledger on 1/4/25.
//

import SwiftUI
import FirebaseAuth

struct EventDetailsView: View {
    @StateObject private var viewModel: EventDetailsViewModel
    let event: Event
    @State private var isAuthenticated = false
    @State private var showSignInOptions = false
    
    init(event: Event) {
        self.event = event
        _viewModel = StateObject(wrappedValue: EventDetailsViewModel(eventId: event.eventId))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            Text(event.name)
                .font(.largeTitle)
                .bold()
            
            // Event Details Section
            Section(
                header: Text("Event Details")
                    .font(.title2)
                    .italic()
            ) {
                Text(event.description)
                
                HStack {
                    Text(event.eventDate, style: .date)
                    Text(event.eventDate, style: .time)
                }
                
                Text("Location: \(event.location)")
            }
            
            Spacer()
            
            // Info Pages Section
            Section(
                header: Text("Info Pages")
                    .font(.title2)
                    .italic()
            ) {
                ForEach(viewModel.infoPages, id: \.title) { page in
                    if page.isPublic {
                        NavigationLink(destination: InfoPageView(eventId: event.eventId, infoPage: page)) {
                            Text(page.title)
                                .font(.headline)
                        }
                    }
                }
            }
            
            Spacer()
            
            // Auth or RSVP
            if viewModel.isAuthenticated {
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
                    viewModel.showSignInOptions = true
                }) {
                    Text("Sign In to RSVP")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .sheet(isPresented: $viewModel.showSignInOptions) {
                    SignInOptionsView(presenting: $viewModel.showSignInOptions)
                        .onDisappear {
                            viewModel.checkAuthStatus()
                        }
                }
            }
        }
        .onAppear {
            viewModel.loadInfoPages()
        }
        .padding()
    }
}

