//
//  EventDetailsViewModel.swift
//  Reunionly
//
//  Created by Terrence Pledger on 1/8/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class EventDetailsViewModel: ObservableObject {
    @Published var infoPages: [InfoPage] = []
    
    var isAuthenticated = false
    var showSignInOptions = false
    
    private let eventId: String
    
    init(eventId: String) {
        self.eventId = eventId
        checkAuthStatus()
        loadInfoPages()
    }
    
    func checkAuthStatus() {
        isAuthenticated = Auth.auth().currentUser != nil
    }
    
    func loadInfoPages() {
        let db = Firestore.firestore()
        
        // Query the events collection to find the document by eventId property
        db.collection("events")
            .whereField("eventId", isEqualTo: eventId)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error finding event document: \(error)")
                    return
                }
                
                guard let eventDoc = snapshot?.documents.first else {
                    print("No matching event document found.")
                    return
                }
                
                let data = eventDoc.data()
                
                if let pages = data["infoPages"] as? [[String: Any]] {
                    self.infoPages = pages.compactMap { page in
                        guard let filename = page["filename"] as? String,
                              let isPublic = page["isPublic"] as? Bool, let title = page["title"] as? String else {
                            return nil
                        }
                        return InfoPage(title: title, filename: filename, isPublic: isPublic)
                    }
                }
            }
    }
}


