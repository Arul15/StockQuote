//
//  StockQuoteDetail.swift
//  CentizenStockQuote
//
//  Created by Shanmuganathan, Arulpandiyan (Chennai) on 05/07/18.
//  Copyright © 2018 Shanmuganathan, Arulpandiyan (Chennai). All rights reserved.
//

import UIKit

class StockQuoteDetailCell: UITableViewCell {

    @IBOutlet var titleDate: UILabel!
    @IBOutlet var openLabel: UILabel!
    @IBOutlet var closeLabel: UILabel!
    @IBOutlet var lowLabel: UILabel!
    @IBOutlet var dividentLabel: UILabel!
    @IBOutlet var highLabel: UILabel!
    @IBOutlet var volumeLabel: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
