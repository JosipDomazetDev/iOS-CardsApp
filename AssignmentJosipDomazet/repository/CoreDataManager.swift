//
//  CoreDataManager.swift
//  AssignmentJosipDomazet
//
//  Created by user on 18.10.23.
//

import CoreData

class CoreDataManager {
    
    
    static let shared = CoreDataManager()
       let persistentContainer: NSPersistentContainer
       
       var viewContext: NSManagedObjectContext {
           return persistentContainer.viewContext
       }
       
       private init() {
           persistentContainer = NSPersistentContainer(name: "AppDataModel")
         
           // load any persistent stores
           persistentContainer.loadPersistentStores { (description, error) in
               if let error = error {
                   fatalError("Unable to initialize Core Data \(error)")
               }
           }
       }
       
       func saveContext() {
           do {
               try viewContext.save()
           } catch {
               viewContext.rollback()
               print(error.localizedDescription)
           }
       }
    


    func clearData() {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Item")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
            saveContext()
        } catch {
            debugPrint("Error clearing data: \(error)")
        }
    }
    
    
    
    func getAllItems() -> [Item] {
        let request = NSFetchRequest<Item>(entityName: "Item")

        do {
            return try viewContext.fetch(request)
        } catch {
            return []
        }
    }
    
    
    func insertItem(item: ItemResponse) -> Item? {
        let itemToBeInserted = Item(context: viewContext)
        
        itemToBeInserted.id = item.id
        itemToBeInserted.title = item.title
        itemToBeInserted.desc = item.description
        itemToBeInserted.imageUrl = item.imageUrl
        
        saveContext()
        
        return itemToBeInserted
    }

    func insertResponseItems(items: [ItemResponse]) -> [Item] {
        var successfullyInsertedItems: [Item] = []

        items.forEach { item in
            if !item.id.isEmpty {
                if let insertedItem = insertItem(item: item) {
                    successfullyInsertedItems.append(insertedItem)
                }
            }
        }

        return successfullyInsertedItems
    }

}
