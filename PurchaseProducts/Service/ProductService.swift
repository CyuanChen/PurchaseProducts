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
// MARK: - public
extension ProductService {
	@discardableResult
	public func addItem(_ id: Int32, _ productID: Int32, _ quantity: Int32, _ lastUpdateUserEntityID: Date? = Date(), _ transientIdentifier: Int32, _ activeFlag: Bool) {
		let item = Item(context: manageObjectContext)
		item.id = id
		item.productItemID = productID
		item.quantity = quantity
		item.lastUpdateUserEntityID
		item.transientIdentifier
		item.activeFlag
//		enum CodingKeys: String, CodingKey {
//			case id
//			case productItemID = "product_item_id"
//			case quantity
//			case lastUpdatedUserEntityID = "last_updated_user_entity_id"
//			case transientIdentifier = "transient_identifier"
//			case activeFlag = "active_flag"
//			case lastUpdated = "last_updated"
//		}
	}
//	func addProductDetail(item: Item?, invoice: Invoice?) {
//		if let item = item {
//			let items = product?.mutableSetValue(forKey: "items")
//			items?.add(item)
//			product?.setValue(items, forKey: "items")
//		}
//
//		if let invoice = invoice {
//			let invoices = product?.mutableSetValue(forKey: "invoices")
//			invoices?.add(invoice)
//			product?.setValue(invoices, forKey: "invoices")
//		}
//		saveContext()
//	}
//
//	func loadSavedData() {
//		let request: NSFetchRequest<Product> = Product.fetchRequest()
//		let sort = NSSortDescriptor(key: "lastUpdated", ascending: false)
//		request.sortDescriptors = [sort]
//		do {
//			// fetch is performed on the NSManagerdObjectContext
//			let products = try context?.fetch(request) ?? []
//			let product = products.first { $0.id == self.product?.id }
//			self.product = product
//		} catch {
//			print("Load saved data failed")
//		}
//	}
}
