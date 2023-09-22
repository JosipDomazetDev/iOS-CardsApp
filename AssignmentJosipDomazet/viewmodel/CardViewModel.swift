//
//  CardViewModel.swift
//  AssignmentJosipDomazet
//
//  Created by user on 22.09.23.
//

import Foundation

class CardViewModel: ObservableObject {
    @Published var viewState: ViewState<[Card]> = .INITIAL
    @Published var combinedCardNames: String = ""
    @Published var pageNumber: Int = 16
    
    private let repository: CardRepository
    
    init(repository: CardRepository) {
        self.repository = repository
    }
    
    func loadCards(fromReload: Bool = false) {
        viewState = .LOADING
        
        repository.fetchCards(page: pageNumber) { [weak self] fetchedCards, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                if let error = error {
                    self.viewState = .ERROR("Failed to load cards: \(error.localizedDescription)")
                    return
                }
                
                guard let fetchedCards = fetchedCards else {
                    self.viewState = .ERROR("Data is null.")
                    return
                }
                
                
                self.viewState = .SUCCESS(fetchedCards.sorted { $0.name < $1.name })
                self.pageNumber += 1
                
                // Check if fetched cards are empty and trigger a reload
                // Only once tho to not cause a recursion by accident (if Magic API was to return an empty page again)
                if (fetchedCards.isEmpty && !fromReload) {
                    self.reloadCards()
                }
                
                
                switch self.viewState {
                case .SUCCESS(let cards):
                    self.combinedCardNames = cards.map { $0.name }.joined(separator: "\n")
                default:
                    self.combinedCardNames = ""
                }
            }
        }
    }
    
    private func reloadCards() {
        self.pageNumber = 1
        self.loadCards(fromReload: true)
    }
}
