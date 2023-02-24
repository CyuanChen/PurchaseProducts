//
//  AddDetailTableViewController.swift
//  PurchaseProducts
//
//  Created by Peter Chen on 13/12/2022.
//

import UIKit
import CoreData
protocol AddDetailDelegate: NSObject {
    func addDetail(item: Item?, invoice: Invoice?)
}
class AddDetailTableViewController: UITableViewController {
    let placeholders = ["Product Item ID", "Quantity", "Invoice Number", "Receive Status"]
    var viewModel: AddDetailViewModel?
    weak var delegate: AddDetailDelegate?
    
    init(viewModel: AddDetailViewModel?) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Add Detail"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        tableView.register(UINib(nibName: "AddDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "AddDetailCell")
    }
    
    @objc func done() {
        let itemAvailable = viewModel?.item?.productItemID ?? 0 > 0 && viewModel?.item?.quantity ?? 0 > 0
        let invoiceAvailable = viewModel?.invoice?.invoiceNumber != nil && viewModel?.invoice?.receivedStatus ?? 0 > 0
        if itemAvailable || invoiceAvailable {
            delegate?.addDetail(item: itemAvailable ? viewModel?.item : nil, invoice: invoiceAvailable ? viewModel?.invoice : nil)
            self.dismiss(animated: true)
        }
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Item"
        } else {
            return "Invoice"
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddDetailCell", for: indexPath) as? AddDetailTableViewCell else {
            return UITableViewCell()
        }
        let tag = indexPath.row + indexPath.section * 2
        cell.dataTextField.tag = tag
        cell.dataTextField.placeholder = placeholders[tag]
        cell.dataTextField.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

}


extension AddDetailTableViewController: UITextFieldDelegate {
    enum TextFieldData: Int {
        case productItemID = 0
        case quantity
        case invoiceNumber =  2
        case receiveStatus
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.addTarget(self, action: #selector(valueChanged), for: .editingChanged)
    }
    @objc func valueChanged(_ textField: UITextField) {
        guard let tagData = TextFieldData(rawValue: textField.tag), let value = textField.text else { return }
        switch tagData {
        case .productItemID:
            if let productID = Int(value) {
                viewModel?.item?.productItemID = Int32(productID)
            }
        case .quantity:
            if let quantity = Int(value) {
                viewModel?.item?.quantity = Int32(quantity)
            }
        case .invoiceNumber:
            viewModel?.invoice?.invoiceNumber = value
        case .receiveStatus:
            if let receiveStatus = Int(value) {
                viewModel?.invoice?.receivedStatus = Int32(receiveStatus)
            }
        }
    }
}
