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

   func saveItems(_ items: [Item]) {
        coreDataManager.context.merge(items)

        do {
            try coreDataManager.context.save()
        } catch {
            fatalError("Failed to save items: \(error.localizedDescription)")
        }
    }

    func retrieveItems(completion: @escaping ([Item]?, Error?) -> Void) {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()

        coreDataManager.context.perform {
            do {
                let items = try coreDataManager.context.fetch(fetchRequest)
                completion(items, nil)
            } catch {
                completion(nil, error)
            }
        }
    }

    func fetchItems(url : String, completion: @escaping ([Item]?, Error?) -> Void) {
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

                self.saveItems(items)

                // TODO complete with SUCCESS in some manner
                // completion(items, nil)
            } catch {
                debugPrint(error)
                completion(nil, error)
            }
        }.resume()
    }
}
