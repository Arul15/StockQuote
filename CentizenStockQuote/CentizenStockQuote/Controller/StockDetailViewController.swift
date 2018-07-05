//
//  StockDetailViewController.swift
//  CentizenStockQuote
//
//  Created by Shanmuganathan, Arulpandiyan (Chennai) on 04/07/18.
//  Copyright © 2018 Shanmuganathan, Arulpandiyan (Chennai). All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire

class StockDetailViewController: UIViewController {
    @IBOutlet var symbolLabel: UILabel!
    @IBOutlet var infolLabel: UILabel!
    @IBOutlet var lastUpdateLabel: UILabel!
    @IBOutlet var stockDetailTableView: UITableView!


    var stockQuote : StockQuoteElement!
    var stockQuoteDetail : StockQuoteDetail!
    var valuesArray : NSMutableArray = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.stockDetailTableView.tableFooterView = UIView()
        loadData()
    }

    @objc func loadData() {
        SVProgressHUD.show()
        let queryItems = [NSURLQueryItem(name: "function", value: "TIME_SERIES_MONTHLY_ADJUSTED"), NSURLQueryItem(name: "symbol", value:stockQuote.the1Symbol), NSURLQueryItem(name: "apikey", value: "MCAF9B429I44328U")]
        let urlComps = NSURLComponents(string: "https://www.alphavantage.co/query")!
        urlComps.queryItems = queryItems as [URLQueryItem]
        let URL = urlComps.url!
        Alamofire.request(URL).responseStockQuoteDetail { response in
            if let stockQuoteDetail = response.result.value {
                self.stockQuoteDetail = stockQuoteDetail
                self.symbolLabel?.text = self.stockQuoteDetail.metaDataDetail?.the2Symbol
                self.infolLabel?.text = self.stockQuoteDetail.metaDataDetail?.the1Information
                self.lastUpdateLabel?.text = self.stockQuoteDetail.metaDataDetail?.the3LastRefreshed
                for (index, element) in (self.stockQuoteDetail?.timeSeriesDaily!.enumerated())!{
                    print("Item \(index): \(element)")
                    let dict : [String:Any] = ["Date": element.key, "Values": element.value]
                    self.valuesArray.add(dict)
                }
                self.stockDetailTableView.reloadData()
                SVProgressHUD.dismiss()
            }
        }
    }
}
extension StockDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows = (valuesArray.count > 0) ? (valuesArray.count) : 0
        return rows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =
            tableView.dequeueReusableCell(
                withIdentifier: "StockQuoteDetailCell", for: indexPath)
                as! StockQuoteDetailCell
        var dict : [String:Any] = valuesArray[indexPath.row] as! [String : Any]
        var dictValues : [String:Any] = dict["Values"] as! [String : Any]
        cell.titleDate?.text = "Date" + (dict["Date"] as? String)!
        cell.openLabel?.text = dictValues["1. open"] as? String
        cell.closeLabel?.text = dictValues["4. close"] as? String
        cell.highLabel?.text = dictValues["2. high"] as? String
        cell.volumeLabel?.text = dictValues["6. volume"] as? String

        return cell
    }
}

