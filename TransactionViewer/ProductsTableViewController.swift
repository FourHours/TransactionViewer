//
//  ProductsTableViewController.swift
//  TransactionViewer
//
//  Created by Q Zhuang on 4/25/17.
//  Copyright © 2017 Q Zhuang. All rights reserved.
//

import UIKit

enum ProductsConfiguation {
    static let cellIdentifier = "Cell"
    static let segueWithIdentifier = "SegueWithIdentifier"
}

class ProductsTableViewController: UITableViewController, DataSourceDelegate {
    let viewModel = ProductsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Products"

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: ProductsConfiguation.cellIdentifier)
        
        viewModel.loadDataSource()
    }

    // MARK: - DataSource Delegate
    
    func productsUpdated() {
        self.tableView.reloadData()
    }
    
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.products.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: ProductsConfiguation.cellIdentifier)
        
        let product = viewModel.products[indexPath.row]
        cell.textLabel?.text = product.sku
        cell.detailTextLabel?.text = viewModel.transactionDescription(product.transactions)
        return cell
    }

    
    // MARK: - Navigation


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ProductsConfiguation.segueWithIdentifier {
            if let nextViewController = segue.destination as? ProductTableViewController {
                let indexPath = self.tableView.indexPathForSelectedRow
                let product = viewModel.products[(indexPath?.row)!]
                nextViewController.product = product
                nextViewController.viewModel = self.viewModel
            }
        }
    }
 
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: ProductsConfiguation.segueWithIdentifier, sender: self)
    }

}
