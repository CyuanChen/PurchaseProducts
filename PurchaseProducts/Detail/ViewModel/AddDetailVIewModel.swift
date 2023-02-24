//
//  AddDetailVIewModel.swift
//  PurchaseProducts
//
//  Created by Peter Chen on 14/12/2022.
//

import Foundation
import CoreData

class AddDetailViewModel {
    var item: Item?
    var invoice: Invoice?
    var context: NSManagedObjectContext?
    init(context: NSManagedObjectContext?) {
        guard let context = context else { return }
        self.context = context
        let item = NSEntityDescription.insertNewObject(forEntityName: "Item", into: context) as? Item
        let invoice = NSEntityDescription.insertNewObject(forEntityName: "Invoice", into: context) as? Invoice
        self.item = item
        self.invoice = invoice
    }
    
}
