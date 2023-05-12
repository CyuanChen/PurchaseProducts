//
//  ProductServiceTests.swift
//  PurchaseProductsTests
//
//  Created by Peter Chen on 26/2/2023.
//

import XCTest
@testable import PurchaseProducts
import CoreData

final class ProductServiceTests: XCTestCase {
	var productService: ProductService!
	var coreDataStack: CoreDataStack!
	
	override func setUp() {
		super.setUp()
		coreDataStack = TestCoreDataStack()
		productService = ProductService(manageObjectContext: CoreDataStack.mainContext, coreDataStack: coreDataStack)
	}
	
	override func tearDown() {
		super.tearDown()
		productService = nil
		coreDataStack = nil
	}
	
	func testAddProduct() {
		let product = productService.addProduct("12345")
		XCTAssertNotNil(product, "Product should not be nil")
		XCTAssertTrue(product.purchaseOrderNumber == "12345")
		XCTAssertNotNil(product.lastUpdated, "LastUpdated should not be nil")
	}
	
	func testRootContextIsSavedAfterAddingProduct() {
		let derivedContext = coreDataStack.newDerivedContext()
		productService = ProductService(manageObjectContext: derivedContext, coreDataStack: coreDataStack)
		expectation(forNotification: .NSManagedObjectContextDidSave, object: CoreDataStack.mainContext) { _ in
			return true
		}
		derivedContext.perform {
			let product = self.productService.addProduct("234567")
			XCTAssertNotNil(product)
		}
		waitForExpectations(timeout: 2.0) { error in
			XCTAssertNil(error, "Save did not occur")
		}
	}
	
	func testGetProducts() {
		productService.addProduct("Paper")
		let pencil = productService.addProduct("Pencil")
		let getProducts = productService.getProducts()
		XCTAssertNotNil(getProducts)
		XCTAssertTrue(getProducts?.count == 2)
		XCTAssertTrue(pencil.purchaseOrderNumber == getProducts?.first?.purchaseOrderNumber)
	}
}
