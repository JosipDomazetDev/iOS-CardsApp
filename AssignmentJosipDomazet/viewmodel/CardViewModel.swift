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
    // 820 seems to be the last page as of now
    @Published var pageNumber: Int = 1
    
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
                // Only once tho, to not cause a recursion by accident (if Magic API was to return an empty page again)
                if (fetchedCards.isEmpty && !fromReload) {
                    self.reloadCards()
                }
                
                
                self.combinedCardNames = self.buildCardString(cards: self.viewState)
            }
        }
    }
    
    private func buildCardString(cards: ViewState<[Card]>) -> String {
        var cardString = ""
        
        guard case .SUCCESS(let cardData) = cards else {
            return cardString
        }
        
        for card in cardData {
            cardString += "\(card.name): \(card.type), \(card.rarity)"
            
            if let colors = card.colors, !colors.isEmpty {
                cardString += ", "
                let displayColors = self.getColorList(card: card)
                cardString += displayColors.joined(separator: ", ")
            }
            
            cardString += "\n"
        }
        
        return cardString
    }
    
 
    private func getColorList(card: Card) -> [String] {
        let colorMapping: [String: String] = [
            "W": "White",
            "U": "Blue",
            "B": "Black",
            "R": "Red",
            "G": "Green"
        ]

        return card.colors?.compactMap { colorMapping[$0] ?? $0 } ?? []
    }
    
     
    private func reloadCards() {
        self.pageNumber = 1
        self.loadCards(fromReload: true)
    }
}
