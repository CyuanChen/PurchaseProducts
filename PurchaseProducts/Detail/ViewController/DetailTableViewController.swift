//
//  DetailTableViewController.swift
//  PurchaseProducts
//
//  Created by Peter Chen on 12/12/2022.
//

import UIKit

class DetailTableViewController: UITableViewController {
    var viewModel: DetailViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Detail"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addDetailItems))
        
        tableView.allowsSelection = false
        tableView.register(UINib(nibName: "DetailTableViewCell", bundle: nil), forCellReuseIdentifier: "DetailTableViewCell")
        loadData()
    }
    
    func loadData() {
        viewModel?.loadSavedData()
        if viewModel?.product != nil {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }

    }
    
    @objc func addDetailItems() {
        let vm = AddDetailViewModel(context: viewModel?.context)
        let vc = AddDetailTableViewController(viewModel: vm)
        vc.delegate = self
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return viewModel?.product?.items?.count ?? 0
        default:
            return viewModel?.product?.invoices?.count ?? 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Items"
        } else {
            return "Invoices"
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let product = viewModel?.product,
              let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell", for: indexPath) as? DetailTableViewCell,
            product.items?.count ?? 0 > 0 || product.invoices?.count ?? 0 > 0 else {
            let cell = UITableViewCell()
            return cell
        }
        
        switch indexPath.section {
        case 0:
            guard let items = product.items?.allObjects as? [Item], items.count > 0, items.count > indexPath.row else { return cell }
            cell.configureCell(item: items[indexPath.row])
        default:
            guard let invoices = product.invoices?.allObjects as? [Invoice], invoices.count > 0, invoices.count > indexPath.row else { return cell }
            cell.configureCell(invoice: invoices[indexPath.row])
        }
        return cell
    }

}

extension DetailTableViewController: AddDetailDelegate {
	func addDetail(item: Item?, invoice: Invoice?, date: Date?) {
        viewModel?.addProductDetail(item: item, invoice: invoice, date: date)
        loadData()
    }
}
