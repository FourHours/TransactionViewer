//
//  ProductTableViewController.swift
//  TransactionViewer
//
//  Created by Q Zhuang on 4/25/17.
//  Copyright © 2017 Q Zhuang. All rights reserved.
//

import UIKit

enum ProductConfiguation {
    static let cellIdentifier = "Cell"
}

class ProductTableViewController: UITableViewController {
    
    var product: Product! = nil
    var viewModel: ProductsViewModel! = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = String("Transactinons for \(self.product.sku)")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: ProductConfiguation.cellIdentifier)
    }



    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.product.transactions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: ProductConfiguation.cellIdentifier)
        
        let transaction = self.product.transactions[indexPath.row]
        cell.textLabel?.text = self.viewModel.formatAmount(transaction)
        cell.detailTextLabel?.text = self.viewModel.amountInPounds(transaction)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Total: \(self.viewModel.total(self.product))"
    }
    
}
