//
//  CardViewModel.swift
//  AssignmentJosipDomazet
//
//  Created by user on 22.09.23.
//

import Foundation

class ItemViewModel: ObservableObject {
    @Published var viewState: ViewState<[Item]> = .INITIAL
    private let repository: ItemRepository
    
    init(repository: ItemRepository) {
        self.repository = repository
    }
    
    func fetchItems(url : String) {
        viewState = .LOADING
        
        repository.fetchItems(url: url){[weak self] items, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                if let error = error {
                    self.viewState = .ERROR("Failed to load: \(error.localizedDescription)")
                    return
                }
                
                guard let items = items else {
                    self.viewState = .ERROR("Data is null.")
                    return
                }
                
                self.retrieveItems(url: url, preventRecursion: true)
                // Completing with items but they are not used to fulfill the "loaded solely from the database" constraint
                // self.viewState = .SUCCESS(items.sorted { ($0.title ?? "") < ($1.title ?? "") })
            }
        }
    }
    
    func retrieveItems(url : String, preventRecursion: Bool) {
        self.viewState = .LOADING
        let retrievedItems: [Item] = repository.retrieveItems()
        self.viewState =  .SUCCESS(retrievedItems.sorted { ($0.title ?? "") < ($1.title ?? "") })
        
        if retrievedItems.isEmpty && !preventRecursion {
            self.fetchItems(url: url)
        }
    }
    
    
    func reloadItems(url: String) {
        // Clear data before fetching
        fetchItems(url: url)
    }
}
