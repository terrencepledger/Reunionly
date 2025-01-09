//
//  CustomSegmentedControl.swift
//  Reunionly
//
//  Created by Terrence Pledger on 1/7/25.
//

import SwiftUI

struct CustomSegmentedControlView: View {
    @Binding var selection: String
    let options: [String]

    var body: some View {
        HStack {
            ForEach(options, id: \.self) { option in
                Button(action: {
                    selection = option
                }) {
                    Text(option)
                        .fontWeight(.semibold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(selection == option ? Color(.systemGray6) : Color.clear)
                        .cornerRadius(8)
                        .foregroundColor(colorForStatus(option))
                        .lineLimit(option == "Not Attending" ? 2 : 1)
                        .minimumScaleFactor(0.5)
                        .multilineTextAlignment(.center)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(4)
        .background(Color(.systemGray5))
        .cornerRadius(10)
    }
    
    func colorForStatus(_ status: String) -> Color {
        if selection != status {
            return .primary
        }
        
        switch status {
        case "Attending":
            return .green
        case "Maybe":
            return .blue
        case "Not Attending":
            return .red
        default:
            return .primary
        }
    }
}
