//
//  CoreDataStack.swift
//  PurchaseProducts
//
//  Created by Peter Chen on 23/2/2023.
//

import Foundation
import CoreData
open class CoreDataStack {
	public static let modelName = "PurchaseProducts"
	public static let model: NSManagedObjectModel = {
	  // swiftlint:disable force_unwrapping
	  let modelURL = Bundle.main.url(forResource: modelName, withExtension: "momd")!
	  return NSManagedObjectModel(contentsOf: modelURL)!
	}()
	
	public init() {
		
	}
	
	public lazy var mainContext: NSManagedObjectContext = {
		return storeContainer.viewContext
	}()
	
	public lazy var storeContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: CoreDataStack.modelName, managedObjectModel: CoreDataStack.model)
		container.loadPersistentStores { _, error in
			if let error = error as NSError? {
				fatalError("Unresolved error: \(error), \(error.userInfo)")
			}
		}
		return container
	}()
	
	public func saveContext() {
		saveContext(mainContext)
	}
	
	public func saveContext(_ context: NSManagedObjectContext) {
		if context != mainContext {
			saveDerivedContext(context)
			return
		}
		context.perform {
			do {
				try context.save()
			} catch let error as NSError {
				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		}
	}
	
	public func saveDerivedContext(_ context: NSManagedObjectContext) {
		context.perform {
			do {
				try context.save()
			} catch let error as NSError {
				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		}
		self.saveContext(self.mainContext)
	}
	
	
}
