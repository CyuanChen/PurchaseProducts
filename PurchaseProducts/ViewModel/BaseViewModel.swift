//
//  BaseViewModel.swift
//  PurchaseProducts
//
//  Created by Peter Chen on 14/12/2022.
//

import Foundation
import CoreData

class BaseViewModel {
    var context: NSManagedObjectContext?
    func saveContext() {
        if context?.hasChanges ?? false {
            do {
                try context?.save()
            } catch {
                print("An error occurred while saving: \(error)")
            }
        }
    }
    
    func loadSavedData() {
    }
}
