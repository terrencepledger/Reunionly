//
//  InfoPageView.swift
//  Reunionly
//
//  Created by Terrence Pledger on 1/9/25.
//

import SwiftUI
import MarkdownUI

struct InfoPageView: View {
    @StateObject private var viewModel: InfoPageViewModel
        
    init(eventId: String, infoPage: InfoPage) {
        _viewModel = StateObject(wrappedValue: InfoPageViewModel(eventId: eventId, infoPage: infoPage))
    }
    
    var body: some View {
        if viewModel.isLoading {
            ProgressView("Loading...")
        } else {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text(viewModel.infoPage.title)
                        .font(.largeTitle)
                        .bold()
                    
                    Markdown(viewModel.markdownContent)
                        .padding()
                }
                .padding()
            }
        }
    }
}
