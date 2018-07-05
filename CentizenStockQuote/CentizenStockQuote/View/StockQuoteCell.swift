//
//  StockQuoteCellTableViewCell.swift
//  CentizenStockQuote
//
//  Created by Shanmuganathan, Arulpandiyan (Chennai) on 04/07/18.
//  Copyright © 2018 Shanmuganathan, Arulpandiyan (Chennai). All rights reserved.
//

import UIKit

class StockQuoteCell: UITableViewCell {

    @IBOutlet var title: UILabel!
    @IBOutlet var lastUpdated: UILabel!
    @IBOutlet var currentPrice: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
