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
    
    func fetchItems() {
        viewState = .LOADING
        
        repository.fetchItems{ [weak self] items, error in
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
                
                
                self.viewState = .SUCCESS(items.sorted { $0.title < $1.title })
            }
        }
    }

 
     
    func reloadItems() {
        self.fetchItems()
    }
}
