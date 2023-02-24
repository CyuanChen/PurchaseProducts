//
//  AddPurchaseViewController.swift
//  PurchaseProducts
//
//  Created by Peter Chen on 13/12/2022.
//

import UIKit
import CoreData

protocol AddPurchaseDelegate: NSObject {
    func addPurchaseProducts(product: Product?)
}
class AddPurchaseViewController: UIViewController {

    @IBOutlet weak var purchaseOrderNumberTextField: UITextField!
    weak var delegate: AddPurchaseDelegate?
    var container: NSPersistentContainer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Add Purchase Order"
        // Do any additional setup after loading the view.
    }

    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func done(_ sender: Any) {
        if let productNumberString = purchaseOrderNumberTextField.text, let productNumber = Int(productNumberString), productNumber > 0, let context = container?.viewContext {
            let product = NSEntityDescription.insertNewObject(forEntityName: "Product", into: context) as? Product
            product?.id = Int32(productNumber)
            product?.lastUpdated = Date()
            delegate?.addPurchaseProducts(product: product)
        }
        
        dismiss(animated: true)
    }
}
