//
//  CardRepository.swift
//  AssignmentJosipDomazet
//
//  Created by user on 22.09.23.
//

import Foundation

class CardRepository {
    func fetchCards(completion: @escaping ([Card]?, Error?) -> Void) {
        let apiURL = URL(string: "https://api.magicthegathering.io/v1/cards")!

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
                let cards = response.cards
                completion(cards, nil)
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
    
    struct Response: Codable {
        let cards: [Card]
    }
}
