//
//  GuestRow.swift
//  Reunionly
//
//  Created by Terrence Pledger on 1/8/25.
//

import SwiftUI

struct GuestRow: View {
    let guest: Guest
    let onEdit: () -> Void
    let onRemove: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Name: \(guest.name)")
                Text("Meal Preference: \(guest.mealPreference)").font(.subheadline)
                Text("Type: \(guest.type)").font(.subheadline)
            }
            Spacer()
            Button(action: onEdit) {
                Image(systemName: "edit")
                    .foregroundColor(.red)
            }
                
            Button(action: onRemove) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
        }
    }
}
