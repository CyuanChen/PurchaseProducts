//
//  ProductTableViewCell.swift
//  PurchaseProducts
//
//  Created by Peter Chen on 10/12/2022.
//

import UIKit

class ProductTableViewCell: UITableViewCell {
    @IBOutlet weak var purchaseOrderIDLabel: UILabel!
    
    @IBOutlet weak var numberOfItemsLabel: UILabel!
    
    @IBOutlet weak var lastedUpdateDateLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        purchaseOrderIDLabel.text = "Purchase Order ID:"
        numberOfItemsLabel.text = "Number of Items:"
        lastedUpdateDateLabel.text = "Last Update Date:"
        lastedUpdateDateLabel.adjustsFontSizeToFitWidth = true
        lastedUpdateDateLabel.minimumScaleFactor = 0.5
    }
    
    func configureCell(_ product: Product) {
        purchaseOrderIDLabel.text = "Purchase Order ID: \(product.id)"
        numberOfItemsLabel.text = "Number of Items: \(product.items?.count ?? 0)"
        if let date = product.lastUpdated {
            let formatter = DateFormatter.iso8601Full
            let string = formatter.string(from: date)
            lastedUpdateDateLabel.text = "Last Update Date: \(string)"
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
