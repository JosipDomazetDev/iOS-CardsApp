//
//  AssignmentJosipDomazetApp.swift
//  AssignmentJosipDomazet
//
//  Created by user on 22.09.23.
//

import SwiftUI

@main
struct AssignmentJosipDomazetApp: App {
    let itemViewModel = ItemViewModel(repository: ItemRepository(coreDataManager: CoreDataManager.shared))
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: itemViewModel).environment(\.managedObjectContext, CoreDataManager.shared.viewContext)
        }
    }
}
