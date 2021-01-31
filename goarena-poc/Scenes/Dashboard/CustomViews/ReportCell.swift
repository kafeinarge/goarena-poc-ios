//
//  ReportCell.swift
//  goarena-poc
//
//  Created by serhat akalin on 31.01.2021.
//

import UIKit

class ReportCell: UITableViewCell {
    @IBOutlet weak var unpaid: UILabel!
    @IBOutlet weak var paid: UILabel!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var total: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
