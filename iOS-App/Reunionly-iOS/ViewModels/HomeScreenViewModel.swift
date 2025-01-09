//
//  HomeScreenViewModel.swift
//  Reunionly
//
//  Created by Terrence Pledger on 1/8/25.
//

import Foundation

@MainActor
class HomeScreenViewModel: ObservableObject {
    @Published var events: [Event] = []
    @Published var isLoading = true
    
    private let eventService = EventService()
    
    init() {
        Task {
            await loadEvents()
        }
    }
    
    func loadEvents() async {
        do {
            events = try await eventService.fetchEvents()
            isLoading = false
        } catch {
            print("Error loading events: \(error)")
            isLoading = false
        }
    }
}
