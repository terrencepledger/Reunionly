//
//  EventService.swift
//  Reunionly
//
//  Created by Terrence Pledger on 1/4/25.
//

import FirebaseFirestore

class EventService {
    private let db = Firestore.firestore()
    
    func fetchEvents() async throws -> [Event] {
        let snapshot = try await db.collection("events").getDocuments()
        return snapshot.documents.compactMap { document in
            try? document.data(as: Event.self)
        }
    }
}
