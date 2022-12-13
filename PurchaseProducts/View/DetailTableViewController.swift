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
        tableView.allowsSelection = false
        tableView.register(UINib(nibName: "DetailTableViewCell", bundle: nil), forCellReuseIdentifier: "DetailTableViewCell")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        if viewModel?.product != nil {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        guard let product = viewModel?.product else { return 0 }
        if product.invoices?.count ?? 0 == 0 && product.items?.count ?? 0 == 0 {
            return 0
        } else if product.invoices?.count ?? 0 > 0 && product.items?.count ?? 0 > 0 {
            return 2
        } else {
            return 1
        }
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let product = viewModel?.product else { return "" }
        if product.invoices?.count ?? 0 > 0 && product.items?.count == 0 {
            return "Invoices"
        } else {
            // items
            // invoices
            if section == 0 {
                return "Items"
            } else {
                return "Invoices"
            }
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let product = viewModel?.product,
              let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell", for: indexPath) as? DetailTableViewCell,
            product.items?.count ?? 0 > 0 || product.invoices?.count ?? 0 > 0 else {
            let cell = UITableViewCell()
            return cell
        }
        if let items = product.items?.allObjects as? [Item], items.count > 0 {
            if let invoices = product.invoices?.allObjects as? [Invoice], invoices.count > 0 {
                if indexPath.section == 0 && items.count > indexPath.row {
                    cell.configureCell(item: items[indexPath.row])
                } else if indexPath.section == 1 && invoices.count > indexPath.row {
                    cell.configureCell(invoice: invoices[indexPath.row])
                }
            } else {
                // only have items
                if items.count > indexPath.row {
                    cell.configureCell(item: items[indexPath.row])
                }
            }
            
        } else {
            if let invoices = product.invoices?.allObjects as? [Invoice], invoices.count > 0, invoices.count > indexPath.row {
                cell.configureCell(invoice: invoices[indexPath.row])
            }
        }

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
