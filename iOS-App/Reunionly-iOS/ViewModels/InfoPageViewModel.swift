//
//  InfoPageViewModel.swift
//  Reunionly
//
//  Created by Terrence Pledger on 1/9/25.
//

import FirebaseFirestore
import FirebaseStorage
import SwiftUI

class InfoPageViewModel: ObservableObject {
    @Published var infoPage: StorageItem
    @Published var markdownContent: String = ""
    @Published var isLoading = false
    
    private let eventId: String
    
    init(eventId: String, infoPage: StorageItem) {
        self.eventId = eventId
        self.infoPage = infoPage
        
        Task {
            await fetchMarkdownContent()
        }
    }
    
    func fetchMarkdownContent() async {
        await MainActor.run {
            isLoading = true
        }
        
        guard let eventDocId = await fetchEventDocId() else {
            await MainActor.run {
                isLoading = false
            }
            return
        }
        
        let storageRef = Storage.storage().reference()
            .child("\(eventDocId)/infoPages/\(infoPage.filename)")
        
        do {
            let data = try await storageRef.data(maxSize: 5 * 1024 * 1024)
            if let content = String(data: data, encoding: .utf8) {
                await MainActor.run {
                    markdownContent = content
                    isLoading = false
                }
            }
        } catch {
            print("Error fetching Markdown content: \(error)")
            await MainActor.run {
                isLoading = false
            }
        }
    }
    
    private func fetchEventDocId() async -> String? {
        let db = Firestore.firestore()
        
        return await withCheckedContinuation { continuation in
            db.collection("events")
                .whereField("eventId", isEqualTo: eventId)
                .getDocuments { snapshot, error in
                    if let error = error {
                        print("Error finding event document: \(error)")
                        continuation.resume(returning: nil)
                        return
                    }
                    
                    guard let eventDoc = snapshot?.documents.first else {
                        print("No matching event document found.")
                        continuation.resume(returning: nil)
                        return
                    }
                    
                    continuation.resume(returning: eventDoc.documentID)
                }
        }
    }
}
