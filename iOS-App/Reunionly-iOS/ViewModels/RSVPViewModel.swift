//
//  RSVPViewModel.swift
//  Reunionly
//
//  Created by Terrence Pledger on 1/8/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class RSVPViewModel: ObservableObject {
    @Published var rsvpDocumentId: String?
    @Published var rsvpStatus = "Attending"
    @Published var mealPreference = ""
    @Published var notes = ""
    @Published var guests: [Guest] = []
    @Published var isLoading = true
    @Published var guestToEdit: Guest?
    
    var userRef: DocumentReference?
    var eventRef: DocumentReference?
    
    let statuses = ["Attending", "Maybe", "Not Attending"]
    
    var isNotAttending: Bool {
        rsvpStatus == "Not Attending"
    }
    
    func loadRSVP(for event: Event) {
        guard let authUser = Auth.auth().currentUser else { return }
        
        let db = Firestore.firestore()
        db.collection("users")
            .whereField("email", isEqualTo: authUser.email ?? "-1")
            .getDocuments { snapshot, error in
                if let userDoc = snapshot?.documents.first {
                    self.userRef = userDoc.reference
                    self.fetchRSVP(for: event)
                } else {
                    self.createUser(authUser: authUser) { userRef in
                        self.userRef = userRef
                        self.fetchRSVP(for: event)
                    }
                }
            }
    }

    private func fetchRSVP(for event: Event) {
        let db = Firestore.firestore()
        
        db.collection("events")
            .whereField("eventId", isEqualTo: event.eventId)
            .getDocuments { snapshot, error in
                guard let eventDoc = snapshot?.documents.first else { return }
                self.eventRef = eventDoc.reference
                
                db.collection("rsvps")
                    .whereField("user", isEqualTo: self.userRef!)
                    .whereField("event", isEqualTo: self.eventRef!)
                    .getDocuments { snapshot, error in
                        if let document = snapshot?.documents.first {
                            self.loadRSVPData(from: document)
                        } else {
                            self.createRSVP()
                        }
                    }
            }
    }

    private func loadRSVPData(from document: QueryDocumentSnapshot) {
        rsvpDocumentId = document.documentID
        rsvpStatus = document.get("status") as? String ?? "Attending"
        mealPreference = document.get("mealPreference") as? String ?? ""
        notes = document.get("notes") as? String ?? ""
        
        if let guestsData = document.get("guests") as? [[String: Any]] {
            guests = guestsData.compactMap { Guest(dictionary: $0) }
        }
        
        isLoading = false
    }

    func addGuest(type: String) {
        let newGuest = Guest(name: "Unnamed \(type)", mealPreference: "", type: type)
        guests.append(newGuest)
    }

    func removeGuest(_ guest: Guest) {
        guests.removeAll { $0.id == guest.id }
    }

    func updateGuest(_ updatedGuest: Guest) {
        if let index = guests.firstIndex(where: { $0.id == updatedGuest.id }) {
            guests[index] = updatedGuest
        }
    }

    func submitRSVP() {
        let db = Firestore.firestore()
        let rsvpData: [String: Any] = [
            "user": userRef as Any,
            "event": eventRef as Any,
            "status": rsvpStatus,
            "mealPreference": mealPreference,
            "notes": notes,
            "guests": guests.map { $0.toDictionary() },
            "lastUpdated": Timestamp()
        ]
        
        if let rsvpDocumentID = rsvpDocumentId {
            db.collection("rsvps").document(rsvpDocumentID).setData(rsvpData) { error in
                if let error = error {
                    print("Error updating RSVP: \(error)")
                } else {
                    print("RSVP updated successfully!")
                }
            }
        } else {
            db.collection("rsvps").addDocument(data: rsvpData) { error in
                if let error = error {
                    print("Error submitting RSVP: \(error)")
                } else {
                    print("RSVP submitted successfully!")
                }
            }
        }
    }
    
    func createUser(authUser: User, completion: @escaping (DocumentReference) -> Void) {
        let db = Firestore.firestore()
        let userData: [String: Any] = [
            "email": authUser.email ?? "",
            "phoneNumber": authUser.phoneNumber ?? "",
            "createdAt": Timestamp()
        ]
        
        let userRef = db.collection("users").document()
        userRef.setData(userData) { error in
            if let error = error {
                print("Error creating user: \(error)")
            } else {
                completion(userRef)
            }
        }
    }
    
    func createRSVP() {
        let db = Firestore.firestore()
        let rsvpData: [String: Any] = [
            "user": userRef as Any,
            "event": eventRef as Any,
            "status": rsvpStatus,
            "mealPreference": mealPreference,
            "notes": notes,
            "guests": guests.map { $0.toDictionary() }
        ]
        
        db.collection("rsvps").addDocument(data: rsvpData) { error in
            if let error = error {
                print("Error creating RSVP: \(error)")
            } else {
                print("RSVP created successfully!")
                self.isLoading = false
            }
        }
    }
}
