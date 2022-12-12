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
        self.purchaseOrderIDLabel.text = "Purchase Order ID:"
        self.numberOfItemsLabel.text = "Number of Items:"
        self.lastedUpdateDateLabel.text = "Last Update Date:"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
