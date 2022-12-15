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
        navigationItem.title = "Purchase Products"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addProduct))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ProductTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductTableViewCell")
        tableView.estimatedRowHeight = 50
        binding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
    }
    
    func binding() {
        viewModel = ProductViewModel(api: "https://my-json-server.typicode.com/butterfly-systems/sample-data/purchase_orders", context: container?.viewContext)
    }
    
    func getData() {
        let userDefault = UserDefaults.standard
        if userDefault.bool(forKey: "GetDataFromAPI") == false {
            viewModel?.getData(completion: { [weak self] success in
                if success {
                    userDefault.set(true, forKey: "GetDataFromAPI")
                    self?.reloadData()
                }
            })
        } else {
            print("Load Saved Data")
            viewModel?.loadSavedData()
            reloadData()
        }
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @objc func addProduct() {
        let vc = AddPurchaseViewController(nibName: "AddPurchaseViewController", bundle: nil)
        let navVC = UINavigationController(rootViewController: vc)
        vc.container = container
        vc.delegate = self
        self.present(navVC, animated: true)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTableViewCell", for: indexPath) as? ProductTableViewCell else {
            return UITableViewCell()
        }
        if let products = viewModel?.products, products.count > indexPath.row {
            cell.configureCell(products[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.products.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailTableViewController()
        if let products = viewModel?.products, products.count > indexPath.row {
            let product = products[indexPath.row]
            let viewModel = DetailViewModel(product: product, context: container?.viewContext)
            vc.viewModel = viewModel
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}

extension ViewController: AddPurchaseDelegate {
    func addPurchaseProducts(product: Product?) {
        if let product = product {
            viewModel?.products.append(product)
            viewModel?.saveContext()
            viewModel?.loadSavedData()
            reloadData()
        }
        
    }
}
