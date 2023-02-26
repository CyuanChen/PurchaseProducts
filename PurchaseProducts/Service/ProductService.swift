//
//  ProductService.swift
//  PurchaseProducts
//
//  Created by Peter Chen on 23/2/2023.
//

import Foundation
import CoreData

public final class ProductService {
	let manageObjectContext: NSManagedObjectContext
	let coreDataStack: CoreDataStack
	public init(manageObjectContext: NSManagedObjectContext, coreDataStack: CoreDataStack) {
		self.manageObjectContext = manageObjectContext
		self.coreDataStack = coreDataStack
	}
}
// MARK: - public, CRUD
extension ProductService {
	@discardableResult
	public func addItem(_ id: Int32, _ productID: Int32, _ quantity: Int32, _ lastUpdateUserEntityID: Int32, _ transientIdentifier: String, _ activeFlag: Bool, _ lastUpdated: Date = Date()) -> Item {
		let item = Item(context: manageObjectContext)
		item.id = id
		item.productItemID = productID
		item.quantity = quantity
		item.lastUpdateUserEntityID = lastUpdateUserEntityID
		item.transientIdentifier = transientIdentifier
		item.activeFlag = activeFlag
		let stringDate = DateFormatter().string(from: lastUpdated)
		let dateFormatter = DateFormatter.iso8601Full
		if let date = dateFormatter.date(from: stringDate) {
			item.lastUpdated = date
		}
		coreDataStack.saveContext(manageObjectContext)
		return item
	}
	
	@discardableResult
	public func addInvoice(_ invoiceNumber: String, _ receivedStatus: Int32) -> Invoice {
		let invoice = Invoice(context: manageObjectContext)
		invoice.invoiceNumber = invoiceNumber
		invoice.receivedStatus = receivedStatus
		coreDataStack.saveContext(manageObjectContext)
		return invoice
	}
	
	@discardableResult
	public func addProduct(_ purchaseOrderNumber: String, _ lastUpdated: Date = Date()) -> Product {
		let product = Product(context: manageObjectContext)
		product.purchaseOrderNumber = purchaseOrderNumber
		product.lastUpdated = lastUpdated
		coreDataStack.saveContext(manageObjectContext)
		return product
	}
	
	public func addProductDetail(_ product: inout Product,item: Item?, invoice: Invoice?) {
		if let item = item {
			let items = product.mutableSetValue(forKey: "items")
			items.add(item)
			product.setValue(items, forKey: "items")
		}

		if let invoice = invoice {
			let invoices = product.mutableSetValue(forKey: "invoices")
			invoices.add(invoice)
			product.setValue(invoices, forKey: "invoices")
		}
		coreDataStack.saveContext(manageObjectContext)
	}
	
	public func getProducts() -> [Product]? {
		let productFetch: NSFetchRequest<Product> = Product.fetchRequest()
		let sort = NSSortDescriptor(key: "lastUpdated", ascending: false)
		productFetch.sortDescriptors = [sort]
		do {
			let results = try manageObjectContext.fetch(productFetch)
			return results
		} catch let error as NSError {
			print("Fetch error: \(error) description: \(error.userInfo)")
		}
		return nil
	}
	
	@discardableResult
	public func updateDateTime(_ product: Product, _ date: Date) -> Product {
		product.lastUpdated = date
		coreDataStack.saveContext(manageObjectContext)
		return product
	}
}
