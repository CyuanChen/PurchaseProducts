//
//  ViewController.swift
//  PurchaseProducts
//
//  Created by Peter Chen on 10/12/2022.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: ProductViewModel?
    var container: NSPersistentContainer?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ProductTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductTableViewCell")
        tableView.estimatedRowHeight = 50
        
        container = NSPersistentContainer(name: "PurchaseProducts")
        container?.loadPersistentStores(completionHandler: { storeDescription, error in
            // resolve conflict by using correct NSMergePolicy
            self.container?.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            if let error = error {
                print("VC unresolved error: \(error)")
            }
        })
        binding()
        
    }
    
    func binding() {
        viewModel = ProductViewModel(api: "https://my-json-server.typicode.com/butterfly-systems/sample-data/purchase_orders", context: container?.viewContext)
        viewModel?.getData(completion: { success in
            if success {
                
            }
        })
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTableViewCell", for: indexPath) as? ProductTableViewCell else {
            return UITableViewCell()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

