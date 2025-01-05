//
//  ReunionlyApp.swift
//  Reunionly
//
//  Created by Terrence Pledger on 1/4/25.
//

import SwiftUI
import SwiftData
import Firebase

@main
struct ReunionlyApp: App {
    var body: some Scene {
        WindowGroup {
            HomeScreenView()
                .onAppear {
                    FirebaseApp.configure()
                }
        }
    }
}
