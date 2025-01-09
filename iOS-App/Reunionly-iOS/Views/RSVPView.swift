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
    @StateObject private var viewModel = RSVPViewModel()
    
    var body: some View {
        Form {
            if viewModel.isLoading {
                ProgressView("Loading...")
            } else {
                rsvpStatusSection
                mealPreferenceSection
                notesSection
                guestsSection
                submitButton
            }
        }
        .navigationTitle("RSVP Form")
        .onAppear {
            viewModel.loadRSVP(for: event)
        }
        .sheet(item: $viewModel.guestToEdit) { guest in
            GuestFormSheetView(guest: guest) { updatedGuest in
                viewModel.updateGuest(updatedGuest)
                viewModel.guestToEdit = nil
            }
        }
    }
    
    // RSVP Status Section
    private var rsvpStatusSection: some View {
        Section(header: Text("RSVP Status")) {
            CustomSegmentedControlView(selection: $viewModel.rsvpStatus, options: viewModel.statuses)
        }
    }
    
    // Meal Preference Section
    private var mealPreferenceSection: some View {
        Section(header: Text("Meal Preference")) {
            TextField(
                "",
                text: $viewModel.mealPreference,
                prompt: Text("Enter meal preference (optional)")
                    .foregroundStyle(viewModel.isNotAttending ? Color.red.opacity(0.5) : .primary.opacity(0.45))
            )
            .foregroundStyle(viewModel.isNotAttending ? .red : .primary)
            .disabled(viewModel.isNotAttending)
        }
    }
    
    // Notes Section
    private var notesSection: some View {
        Section(header: Text("Notes")) {
            TextField(
                "",
                text: $viewModel.notes,
                prompt: Text("Add a note (optional)")
                    .foregroundStyle(viewModel.isNotAttending ? Color.red.opacity(0.5) : .primary.opacity(0.45))
            )
            .foregroundStyle(viewModel.isNotAttending ? .red : .primary)
            .disabled(viewModel.isNotAttending)
        }
    }
    
    // Guests Section
    private var guestsSection: some View {
        Section(header: HStack {
            Text("Guests")
                .font(.headline)
            
            Spacer()
            
            Button(action: {
                withAnimation {
                    viewModel.addGuest(type: "Adult")
                }
            }) {
                Text("Add Adult")
                    .padding(8)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .disabled(viewModel.isNotAttending)
            
            Button(action: {
                withAnimation {
                    viewModel.addGuest(type: "Child")
                }
            }) {
                Text("Add Child")
                    .padding(8)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .disabled(viewModel.isNotAttending)
        }) {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(viewModel.guests) { guest in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Name: \(guest.name)")
                                    
                                    Text("Meal Preference: \(guest.mealPreference)")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    
                                    Text("Type: \(guest.type)")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                Button {
                                    viewModel.guestToEdit = guest
                                } label: {
                                    Text("Edit")
                                        .padding()
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                }
                                
                                Button(action: {
                                    withAnimation {
                                        viewModel.removeGuest(guest)
                                    }
                                }) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                                .padding(.leading)
                            }
                            .padding(.vertical, 8)
                            .id(guest.id)
                        }
                    }
                    .padding(.horizontal)
                    .onChange(of: viewModel.guests.count) { _,_ in
                        withAnimation {
                            proxy.scrollTo(viewModel.guests.last?.id, anchor: .bottom)
                        }
                    }
                }
                .frame(height: max(min(CGFloat(viewModel.guests.count) * 60, 180), 75))
                .background {
                    viewModel.rsvpStatus == "Not Attending" ?
                    RoundedRectangle(cornerRadius: 8)
                            .fill(Color.red.opacity(0.35)) : RoundedRectangle(cornerRadius: 8)
                            .fill(Color.clear)
                }
                .disabled(viewModel.rsvpStatus == "Not Attending")
            }
        }
    }
    
    // Submit Button
    private var submitButton: some View {
        Button("Submit RSVP") {
            viewModel.submitRSVP()
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(8)
    }
}

extension Int: @retroactive Identifiable {
    public var id: Int { return self }
}
