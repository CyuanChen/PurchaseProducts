//
//  DetailTableViewCell.swift
//  PurchaseProducts
//
//  Created by Peter Chen on 13/12/2022.
//

import UIKit

class DetailTableViewCell: UITableViewCell {

    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func clear() {
        idLabel.text = nil
        detailLabel.text = nil
    }
    
    func configureCell(item: Item) {
        clear()
        idLabel.text = "Item ID: \(item.productItemID)"
        detailLabel.text = "Quantity: \(item.quantity)"
    }
    
    func configureCell(invoice: Invoice) {
        clear()
        if let invoiceNumber = invoice.invoiceNumber {
            idLabel.text = "Invoice number: \(invoiceNumber)"
        }
        detailLabel.text = "Received status: \(invoice.receivedStatus)"
    }
}
