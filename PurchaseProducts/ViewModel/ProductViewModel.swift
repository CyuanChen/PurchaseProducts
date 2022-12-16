//
//  ProductViewModel.swift
//  PurchaseProducts
//
//  Created by Peter Chen on 10/12/2022.
//

import Foundation
import CoreData

class ProductViewModel: BaseViewModel {
    var api: String
    var products: [Product] = []
    init(api: String, context: NSManagedObjectContext?) {
        self.api = api
        super.init()
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
                completion(false)
                return print("*** Fetch Error: \(error.debugDescription)")
            }
            let decoder = JSONDecoder()
            guard let data = data,
                  let userInfoKeyContext = CodingUserInfoKey.context else {
                completion(false)
                return
            }
            decoder.userInfo[userInfoKeyContext] = self?.context
            do {
                let products = try decoder.decode([Product].self, from: data)
                self?.products = products
                self?.saveContext()
                self?.loadSavedData()
                completion(true)
            } catch {
                print(error)
                completion(false)
            }
        }
        task.resume()
    }
    
    override func loadSavedData() {
        let request: NSFetchRequest<Product> = Product.fetchRequest()
        let sort = NSSortDescriptor(key: "lastUpdated", ascending: false)
        request.sortDescriptors = [sort]
        do {
            // fetch is performed on the NSManagerdObjectContext
            products = try context?.fetch(request) ?? []
        } catch {
            print("Load saved data failed")
        }
    }
}
