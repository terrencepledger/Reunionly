//
//  HomeScreenView.swift
//  Reunionly
//
//  Created by Terrence Pledger on 1/4/25.
//


import SwiftUI
import FirebaseFirestore

struct HomeScreenView: View {
    @StateObject private var viewModel = HomeScreenViewModel()
    
    var body: some View {
        NavigationView {
            if viewModel.isLoading {
                ProgressView("Loading Events...")
            } else {
                List(viewModel.events) { event in
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
    }
}
