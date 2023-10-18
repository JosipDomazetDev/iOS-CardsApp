//
//  CardRepository.swift
//  AssignmentJosipDomazet
//
//  Created by user on 22.09.23.
//

import Foundation

class ItemRepository {
   private let coreDataManager: CoreDataManager

    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }


    func retrieveItems() -> [Item] {
        return coreDataManager.getAllItems()
    }
    

    func fetchItems(url : String, completion: @escaping ([Item]?, Error?) -> Void) {
        print("Fetching items")
        guard let apiURL = URL(string: url) else {
            completion(nil, (NSError(domain: "AppErrorDomain", code: 0, userInfo: nil)))
            return
        }   
        
        URLSession.shared.dataTask(with: apiURL) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NSError(domain: "AppErrorDomain", code: 0, userInfo: nil))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(Response.self, from: data)
                let items = response.items
                
         
                print("Got \(items.count) items")
                let successfullyInsertedItems: [Item] = self.coreDataManager.insertResponseItems(items: items)
                
                completion(successfullyInsertedItems, nil)
            } catch {
                debugPrint(error)
                completion(nil, error)
            }
        }.resume()
    }
    
    func clearData(){
        return coreDataManager.clearData()
    }
    
}
