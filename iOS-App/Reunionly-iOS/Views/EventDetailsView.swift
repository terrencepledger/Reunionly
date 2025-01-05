//
//  EventDetailsScreen.swift
//  Reunionly
//
//  Created by Terrence Pledger on 1/4/25.
//

import SwiftUI

struct EventDetailsView: View {
    let event: Event

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(event.name)
                .font(.largeTitle)
                .bold()
            Text(event.description)
                .font(.title2)
                .italic()
            HStack {
                Text(event.eventDate, style: .date)
                    .font(.title2)
                Text(event.eventDate, style: .time)
                    .font(.title2)
            }
            Text("Location: \(event.location)")
                .font(.title3)
        }
        .padding()
        .navigationTitle("Event Details")
    }
}
