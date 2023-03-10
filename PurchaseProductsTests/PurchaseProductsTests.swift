//
//  PurchaseProductsTests.swift
//  PurchaseProductsTests
//
//  Created by Peter Chen on 10/12/2022.
//

import XCTest
import CoreData
@testable import PurchaseProducts

final class PurchaseProductsTests: XCTestCase {
    var sut: ProductViewModel!
    lazy var mockPersistantContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PurchaseProducts")
        let description = NSPersistentStoreDescription()
        // make sure will remove data when terminate the app
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { description, error in
            precondition(description.type == NSInMemoryStoreType)
            if let error = error {
                fatalError("Create an in-mem coordinator failed")
            }
        }
        return container
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle(for: type(of: self))])!
        return managedObjectModel
    }()
    
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = ProductViewModel(api: "https://my-json-server.typicode.com/butterfly-systems/sample-data/purchase_orders", context: mockPersistantContainer.viewContext)
        initProducts()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testAPI() throws {
        let api = "https://my-json-server.typicode.com/butterfly-systems/sample-data/purchase_orders"
        guard let url = URL(string: api) else {
            return
        }
        let urlRequest = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                return
            }
            if let data = data {
                let string = String(data: data, encoding: .utf8)
                XCTAssertNil(string)
            }
        }
        task.resume()
    }
    
    func testGetData() throws {
        let promise = expectation(description: "product not nil")
        sut.getData { [weak self] successful in
            if successful {
                promise.fulfill()
            } else {
                XCTFail("get data failed")
            }
        }
        wait(for: [promise], timeout: 5)
    }
    
    func testLoadData() throws {
        sut.loadSavedData()
        let results = sut.products
        // return two mock products
        XCTAssertEqual(results.count, 2)
    }
    

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

extension PurchaseProductsTests {
    func initProducts() {
        func insertProduct(id: Int32) -> Product? {
            let product = NSEntityDescription.insertNewObject(forEntityName: "Product", into: mockPersistantContainer.viewContext) as? Product
            product?.setValue(id, forKey: "id")
            if let item = NSEntityDescription.insertNewObject(forEntityName: "Item", into: mockPersistantContainer.viewContext) as? Item {
                item.productItemID = 123
                item.quantity = 1
                product?.setValue(NSSet(object: item), forKey: "items")
            }
            if let invoice = NSEntityDescription.insertNewObject(forEntityName: "Invoice", into: mockPersistantContainer.viewContext) as? Invoice {
                invoice.invoiceNumber = "1231231"
                invoice.receivedStatus = 12
                product?.setValue(NSSet(object: invoice), forKey: "invoices")
            }
            return product
        }
        _ = insertProduct(id: 12)
        _ = insertProduct(id: 1234)
        do {
            try mockPersistantContainer.viewContext.save()
        } catch {
            print("create fakes error \(error)")
        }
    }
}
