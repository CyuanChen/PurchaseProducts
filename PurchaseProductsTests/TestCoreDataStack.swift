//
//  TestCoreDataStack.swift
//  PurchaseProductsTests
//
//  Created by Peter Chen on 22/2/2023.
//

import XCTest
import Foundation
import CoreData
import PurchaseProducts


class TestCoreDataStack: CoreDataStack {
	override init() {
		super.init()
		let persistentStoreDescription = NSPersistentStoreDescription()
		// https://medium.com/tiendeo-tech/ios-how-to-unit-test-core-data-eb4a754f2603
		// Apple Suggestion
		persistentStoreDescription.url = URL(filePath: "/dev/null")
		let container = NSPersistentContainer(name: CoreDataStack.modelName, managedObjectModel: CoreDataStack.model)
		container.persistentStoreDescriptions = [persistentStoreDescription]
		container.loadPersistentStores { _, error in
			if let error = error as NSError? {
				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		}
		storeContainer = container
	}
}
