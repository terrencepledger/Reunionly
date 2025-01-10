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
        if viewModel.isLoading {
            ProgressView("Loading...")
        } else {
            VStack(alignment: .leading, spacing: 20) {
                Text(event.name)
                    .font(.largeTitle)
                    .bold()
                
                Spacer()
                
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
                if !viewModel.infoPages.isEmpty {
                    Section(
                        header: Text("Info")
                            .font(.title2)
                            .italic()
                    ) {
                        ForEach($viewModel.infoPages, id: \.title) { page in
                            if page.isPublic.wrappedValue {
                                NavigationLink(destination: InfoPageView(eventId: event.eventId, infoPage: page.wrappedValue)) {
                                    Text(page.title.wrappedValue)
                                        .font(.headline)
                                }
                            }
                        }
                    }
                }
                
                // Documents Section
                if !viewModel.documents.isEmpty {
                    Section(
                        header: Text("Downloadable Documents")
                            .font(.title2)
                            .italic()
                    ) {
                        ForEach($viewModel.documents, id: \.title) { document in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(document.filename.wrappedValue)
                                        .font(.headline)
                                }
                                Spacer()
                                Button(action: {
                                    Task {
                                        viewModel.isLoading = true
                                        if let url = await viewModel.downloadDocument(for: document.wrappedValue) {
                                            viewModel.openDocument(at: url)
                                        }
                                        viewModel.isLoading = false
                                    }
                                }) {
                                    Image(systemName: "arrow.down.circle")
                                        .font(.title2)
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                    }
                }
                
                Spacer()
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
                                viewModel.load()
                            }
                    }
                }
            }
            .padding()
        }
    }
}

