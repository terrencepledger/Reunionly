//
//  HomeScreenView.swift
//  Reunionly
//
//  Created by Terrence Pledger on 1/4/25.
//


import SwiftUI
import FirebaseFirestore

struct HomeScreenView: View {
    @State private var events: [Event] = []
    @State private var isLoading = true
    
    var body: some View {
        NavigationView {
            if isLoading {
                ProgressView("Loading Events...")
            } else {
                List(events) { event in
                    NavigationLink(destination: EventDetailsView(event: event)) {
                        VStack(alignment: .leading) {
                            Text(event.name)
                                .font(.headline)
                            Text(event.eventDate, style: .date)
                                .font(.subheadline)
                            Text(event.location)
                                .font(.subheadline)
                        }
                    }
                }
                .navigationTitle("Upcoming Events")
            }
        }
        .task {
            await loadEvents()
        }
    }
    
    func loadEvents() async {
        do {
            let eventService = EventService()
            events = try await eventService.fetchEvents()
            isLoading = false
        } catch {
            print("Error loading events: \(error)")
        }
    }
}
