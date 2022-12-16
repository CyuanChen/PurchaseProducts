//
//  DetailViewModel.swift
//  PurchaseProducts
//
//  Created by Peter Chen on 13/12/2022.
//

import Foundation
import CoreData

class DetailViewModel: BaseViewModel {
    var product: Product?
    
    init(product: Product, context: NSManagedObjectContext?) {
        super.init()
        self.product = product
        self.context = context
    }
    
    func addProductDetail(item: Item?, invoice: Invoice?) {
        if let item = item {
            let items = product?.mutableSetValue(forKey: "items")
            items?.add(item)
            product?.setValue(items, forKey: "items")
        }
        
        if let invoice = invoice {
            let invoices = product?.mutableSetValue(forKey: "invoices")
            invoices?.add(invoice)
            product?.setValue(invoices, forKey: "invoices")
        }
        saveContext()
    }
    
    override func loadSavedData() {
        let request: NSFetchRequest<Product> = Product.fetchRequest()
        let sort = NSSortDescriptor(key: "lastUpdated", ascending: false)
        request.sortDescriptors = [sort]
        do {
            // fetch is performed on the NSManagerdObjectContext
            let products = try context?.fetch(request) ?? []
            let product = products.first { $0.id == self.product?.id }
            self.product = product
        } catch {
            print("Load saved data failed")
        }
    }
}
