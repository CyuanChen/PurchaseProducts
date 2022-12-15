//
//  AddDetailTableViewCell.swift
//  PurchaseProducts
//
//  Created by Peter Chen on 14/12/2022.
//

import UIKit

class AddDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var dataTextField: UITextField!
    var placeHolder: String? {
        didSet {
            guard let item = placeHolder else { return }
            dataTextField.placeholder = item
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
