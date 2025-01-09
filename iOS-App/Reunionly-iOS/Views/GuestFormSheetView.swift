//
//  GuestFormView.swift
//  Reunionly
//
//  Created by Terrence Pledger on 1/6/25.
//


import SwiftUI

struct GuestFormSheetView: View {
    let guestTypes = ["Adult", "Child"]
    
    @State var guest: Guest
    var onSave: (Guest) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Guest Details")) {
                    TextField("Name", text: $guest.name)
                    TextField("Meal Preference", text: $guest.mealPreference)
                    
                    Picker("Type", selection: $guest.type) {
                        ForEach(guestTypes, id: \.self) { type in
                            Text(type)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Button("Save Guest") {
                    onSave(guest)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .navigationTitle("Add/Edit Guest")
        }
    }
}
