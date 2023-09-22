//
//  CardViewModel.swift
//  AssignmentJosipDomazet
//
//  Created by user on 22.09.23.
//

import Foundation

class CardViewModel: ObservableObject {
    @Published var viewState: ViewState<[Card]> = .INITIAL

    private let repository: CardRepository

    init(repository: CardRepository) {
        self.repository = repository
    }

    func loadCards() {
        viewState = .LOADING

        repository.fetchCards { [weak self] fetchedCards, error in
            DispatchQueue.main.async {
                guard let self = self else { return }

                if let error = error {
                    self.viewState = .ERROR("Failed to load cards: \(error.localizedDescription)")
                    return
                }

                guard let fetchedCards = fetchedCards else {
                    self.viewState = .ERROR("Data is empty.")
                    return
                }

                self.viewState = .SUCCESS(fetchedCards.sorted { $0.name < $1.name })
            }
        }
    }
}
