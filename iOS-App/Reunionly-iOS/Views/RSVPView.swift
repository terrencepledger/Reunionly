//
//  RSVPView.swift
//  Reunionly
//
//  Created by Terrence Pledger on 1/6/25.
//


import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct RSVPView: View {
    let event: Event
    @State private var rsvpStatus = "Not Responded"
    @State private var mealPreference = ""
    @State private var notes = ""
    @State private var isLoading = true

    let statuses = ["Attending", "Not Attending", "Maybe"]

    var body: some View {
        Form {
            if isLoading {
                ProgressView("Loading...")
            } else {
                Section(header: Text("Your RSVP Status")) {
                    Picker("Status", selection: $rsvpStatus) {
                        ForEach(statuses, id: \.self) { status in
                            Text(status)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }

                Section(header: Text("Meal Preference")) {
                    TextField("Enter meal preference (optional)", text: $mealPreference)
                }

                Section(header: Text("Notes")) {
                    TextField("Add a note (optional)", text: $notes)
                }

                Button(action: updateRSVP) {
                    Text("Update RSVP")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
        }
        .navigationTitle("RSVP")
        .onAppear {
            loadRSVP()
        }
    }

    func loadRSVP() {
        let db = Firestore.firestore()
        
        db.collection("rsvps")
            .whereField("eventId", isEqualTo: event.eventId)
            .whereField("email", isEqualTo: "johndoe@gmail.com")
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error loading RSVP: \(error)")
                    isLoading = false
                    return
                }

                if let document = snapshot?.documents.first {
                    rsvpStatus = document.get("status") as? String ?? "Not Responded"
                    mealPreference = document.get("mealPreference") as? String ?? ""
                    notes = document.get("notes") as? String ?? ""
                }
                isLoading = false
            }
    }

    func updateRSVP() {
        guard let user = Auth.auth().currentUser else { return }
        let db = Firestore.firestore()

        let rsvpData: [String: Any] = [
            "userId": user.uid,
            "eventId": event.eventId,
            "status": rsvpStatus,
            "mealPreference": mealPreference,
            "notes": notes,
            "timestamp": Timestamp()
        ]

        db.collection("rsvps")
            .whereField("eventId", isEqualTo: event.eventId)
            .whereField("userId", isEqualTo: user.uid)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error finding RSVP: \(error)")
                    return
                }

                if let document = snapshot?.documents.first {
                    document.reference.updateData(rsvpData) { error in
                        if let error = error {
                            print("Error updating RSVP: \(error)")
                        } else {
                            print("RSVP updated successfully!")
                        }
                    }
                } else {
                    db.collection("rsvps").addDocument(data: rsvpData) { error in
                        if let error = error {
                            print("Error adding RSVP: \(error)")
                        } else {
                            print("RSVP added successfully!")
                        }
                    }
                }
            }
    }
}
