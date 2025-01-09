//
//  EventDetailsViewModel.swift
//  Reunionly
//
//  Created by Terrence Pledger on 1/8/25.
//

import Foundation
import FirebaseAuth

class EventDetailsViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var showSignInOptions = false
    
    init() {
        checkAuthStatus()
    }
    
    func checkAuthStatus() {
        isAuthenticated = Auth.auth().currentUser != nil
    }
}
