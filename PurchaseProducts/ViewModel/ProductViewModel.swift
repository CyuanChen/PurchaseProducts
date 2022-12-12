//
//  ProductViewModel.swift
//  PurchaseProducts
//
//  Created by Peter Chen on 10/12/2022.
//

import Foundation
import CoreData

class ProductViewModel {
    var api: String
    var products: [Product]?
    var context: NSManagedObjectContext?
    init(api: String, context: NSManagedObjectContext?) {
        self.api = api
        self.context = context
    }
    func getData(completion: @escaping (Bool) -> ()) {
        guard let url = URL(string: api) else {
            completion(false)
            return
        }
        let urlRequest = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: urlRequest) { [weak self] data, response, error in
            guard error == nil else {
                return print("*** Fetch Error: \(error.debugDescription)")
            }
            if let data = data, let string = String(data: data, encoding: .utf8) {
                print(string)
                let decoder = JSONDecoder()
                guard let userInfoKeyContext = CodingUserInfoKey.context else {
                    completion(false)
                    return
                }
                decoder.userInfo[userInfoKeyContext] = self?.context
                do {
                    let products = try decoder.decode([Product].self, from: data)
                    self?.products = products
                } catch {
                    print(error)
                }
            }
        }
        task.resume()
    }
}
