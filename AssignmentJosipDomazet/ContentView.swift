//
//  ContentView.swift
//  AssignmentJosipDomazet
//
//  Created by user on 22.09.23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var viewModel: CardViewModel
    
    init(viewModel: CardViewModel) {
        self.viewModel = viewModel
    }
    
    func errorWidget(_ errorMessage: String) -> Text {
        print(errorMessage)
        return Text("Error: \(errorMessage)")
    }
    
    var body: some View {
        VStack {
            HStack {
                if viewModel.pageNumber-1 != 0 {
                    HStack {
                        Text("Page \(viewModel.pageNumber - 1)")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                }
            }
            
            switch viewModel.viewState {
            case .INITIAL:
                Text("Press the button to load cards.")
            case .LOADING:
                ProgressView("Loading...")
            case .ERROR(let errorMessage):
                errorWidget(errorMessage)
                    .foregroundColor(.red)
            case .SUCCESS(let cards):
                ScrollView {
                    Text(viewModel.combinedCardNames)
                }
            }
            
            Button(action: {
                viewModel.loadCards()
            }) {
                Text("Load Cards")
            }
            .disabled(viewModel.viewState == .LOADING)
        }
    }
}

