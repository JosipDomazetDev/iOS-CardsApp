//
//  CardRepository.swift
//  AssignmentJosipDomazet
//
//  Created by user on 22.09.23.
//

import Foundation

class ItemRepository {
    func fetchItems(completion: @escaping ([Item]?, Error?) -> Void) {
        guard let apiURL = URL(string: "https://api.magicthegathering.io/v1/cards") else {
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
                completion(items, nil)
            } catch {
                debugPrint(error)
                completion(nil, error)
            }
        }.resume()
    }
}
