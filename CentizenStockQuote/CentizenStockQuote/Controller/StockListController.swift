//
//  ViewController.swift
//  CentizenStockQuote
//
//  Created by Shanmuganathan, Arulpandiyan (Chennai) on 02/07/18.
//  Copyright © 2018 Shanmuganathan, Arulpandiyan (Chennai). All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class StockListController: UIViewController {
    @IBOutlet weak var stocktableView: UITableView!
    var stockQuote : StockQuote!
    var refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        refreshData()
        loadData()
    }

    func refreshData(){
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(loadData), for: UIControlEvents.valueChanged)
        stocktableView.addSubview(refreshControl)
    }
    
    @objc func loadData() {
        SVProgressHUD.show()
        let queryItems = [NSURLQueryItem(name: "function", value: "BATCH_STOCK_QUOTES"), NSURLQueryItem(name: "symbols", value: "AAPL,AAL,ADBE,ADI,ADP,CA,CTSH,EBAY,MSFT,FB,INFY,HAS,INTC,MCHP"), NSURLQueryItem(name: "apikey", value: "MCAF9B429I44328U")]
        let urlComps = NSURLComponents(string: "https://www.alphavantage.co/query")!
        urlComps.queryItems = queryItems as [URLQueryItem]
        let URL = urlComps.url!
           Alamofire.request(URL).responseStockQuote { response in
            if let stockQuote = response.result.value {
                self.stockQuote = stockQuote
                self.stocktableView.reloadData()
                self.refreshControl.endRefreshing()
                SVProgressHUD.dismiss()
             }
           }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension StockListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows = (stockQuote != nil) ? (stockQuote?.stockQuotes?.count)! : 0
        return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let stockElement = stockQuote?.stockQuotes![indexPath.row]
        let cell =
            tableView.dequeueReusableCell(
                withIdentifier: "StockQuoteCell", for: indexPath)
                as! StockQuoteCell
        cell.title?.text = stockElement?.the1Symbol
        cell.currentPrice?.text = "$" + (stockElement?.the2Price)!
        cell.lastUpdated?.text = stockElement?.the4Timestamp
        return cell
    }
}

extension StockListController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "StockDetail", sender: nil)
        
    }
}
