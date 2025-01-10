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

@MainActor
class EventDetailsViewModel: NSObject, ObservableObject {
    @Published var infoPages: [StorageItem] = []
    @Published var documents: [StorageItem] = []
    @Published var isLoading = false
    
    var isAuthenticated = false
    var showSignInOptions = false
    
    private let eventId: String
    private let db = Firestore.firestore()
    
    init(eventId: String) {
        self.eventId = eventId
        super.init()
        load()
    }
    
    func load() {
        isLoading = true
        checkAuthStatus()
        Task {
            self.infoPages = await loadStorageItems(from: "infoPages")
        }
        Task {
            self.documents = await loadStorageItems(from: "documents")
        }
    }
    
    func downloadDocument(for document: StorageItem) async -> URL? {
        guard let eventDoc = try? await getEventRef()?.getDocument() else {
            print("No matching event document found.")
            return nil
        }
        let eventDocId = eventDoc.documentID
        let storageRef = Storage.storage().reference().child("\(eventDocId)/documents/\(document.filename)")
        
        do {
            let data = try await storageRef.data(maxSize: 10 * 1024 * 1024) // 10 MB limit
            
            // Save to temporary directory
            let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(document.filename)
            try data.write(to: tempURL)
            
            print("Document downloaded to: \(tempURL)")
            return tempURL
        } catch {
            print("Error downloading document: \(error)")
            return nil
        }
    }
    
    func openDocument(at url: URL) {
        let documentController = UIDocumentInteractionController(url: url)
        documentController.delegate = self
        
        documentController.presentPreview(animated: true)
    }
    
    private func getEventRef() async -> DocumentReference? {
        let snapshot = try? await db.collection("events")
            .whereField("eventId", isEqualTo: eventId)
            .getDocuments()
        
        return snapshot?.documents.first?.reference
    }
    
    private func checkAuthStatus() {
        isAuthenticated = Auth.auth().currentUser != nil
        isLoading = false
    }
    
    private func loadStorageItems(from fieldName: String) async -> [StorageItem] {
        guard let eventDoc = try? await getEventRef()?.getDocument(), let data = eventDoc.data() else {
            print("No matching event document found.")
            return []
        }
        
        if let itemsArray = data[fieldName] as? [[String: Any]] {
            return itemsArray.compactMap { item in
                guard let filename = item["filename"] as? String,
                      let isPublic = item["isPublic"] as? Bool,
                      let title = item["title"] as? String, let isPublic = item["isPublic"] as? Bool, isPublic else {
                    return nil
                }
                return StorageItem(title: title, filename: filename, isPublic: isPublic)
            }
        } else {
            print(String(describing: data))
            return []
        }
    }
}

extension EventDetailsViewModel: UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        guard let rootViewController = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows.first?.rootViewController else {
            fatalError("Unable to get root view controller.")
        }
        return rootViewController
    }
}


