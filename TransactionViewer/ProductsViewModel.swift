//
//  ProductsTableViewControllerViewModel.swift
//  TransactionViewer
//
//  Created by Q Zhuang on 4/25/17.
//  Copyright © 2017 Q Zhuang. All rights reserved.
//

import Foundation

enum ProductsViewModelConfiguration {
    static let transactionsFilename = "transactions"
    static let ratesFileName = "rates"
}

class ProductsViewModel {
    
    weak var delegate: DataSourceDelegate?
    var products = [Product]()
    var ratesTable = [String: Double]() // USD -> 1.2
    
    func loadRates() {
        guard let path = Bundle.main.path(forResource: ProductsViewModelConfiguration.ratesFileName, ofType: "plist")
            else {
                return
        }
        
        self.ratesTable.removeAll()
        var currencies = Set<String>()
        if let array = NSArray(contentsOfFile: path) as? [[String: Any]] {
            array.forEach({ (element) in
                let value = element["rate"] as! String
                let from = element["from"] as! String
                let to = element["to"] as! String
                if to == "GBP" {
                    self.ratesTable[from] = Double(value)
                }
                
                currencies.insert(from)
                currencies.insert(to)
            })
            
            self.ratesTable["GBP"] = 1.0

            currencies.forEach { (currency) in
                if self.ratesTable[currency] == nil {
                    array.forEach({ (element) in
                        let value = element["rate"] as! String
                        let from = element["from"] as! String
                        let to = element["to"] as! String
                        
                        if from == currency {
                            self.ratesTable[to] = self.ratesTable[to]! / Double(value)!
                        }

                        if to == currency {
                            self.ratesTable[to] = self.ratesTable[from]! * Double(value)!
                        }
                    })
                }
            }
        }
    }
    
    func loadDataSource() {
        
        loadRates()
        
        guard let path = Bundle.main.path(forResource: ProductsViewModelConfiguration.transactionsFilename, ofType: "plist")
            else {
                return
        }

        var elements = [Element]()
        if let array = NSArray(contentsOfFile: path) as? [[String: Any]] {
            array.forEach({ (element) in
                elements.append(Element(dic: element))
            })
        }
        
        var hashTable = [String: [Element]]()
        elements.forEach { (element) in
            if let list = hashTable[element.sku] {
                hashTable[element.sku] = list + [element]
            }
            else {
                hashTable[element.sku] = [element]
            }
        }
        
        products.removeAll()
        for (key, value) in hashTable {
            let transactions = value.map { Transaction(amount: $0.amount, currency: $0.currency, amountInPounds: 0) }
            products.append(Product(sku: key, transactions: transactions))
        }
        
        if let delegate = self.delegate {
            delegate.productsUpdated()
        }
    }
    
    func formatAmount (_ transaction: Transaction) -> String {
        return transaction.currency + String.init(format: "%.2f", transaction.amount)
    }
    
    func total(_ product: Product) -> String {
        
        var sum = 0.0
        
        product.transactions.forEach { (transaction) in
            let currency = transaction.currency
            
            if let rate = self.ratesTable[currency] {
              sum = sum + transaction.amount*rate
            }
        }
        
        return String.init(format: "£%.2f", sum)
    }
    
    func amountInPounds(_ transaction: Transaction) -> String {
        var output = ""
        let currency = transaction.currency
        
        if let rate = self.ratesTable[currency] {
            output = self.formatAmountInPounds(transaction.amount*rate)
        }
        return output
    }
    
    func transactionDescription(_ transactions: [Transaction]) -> String {
        return String("\(transactions.count) transactions")
    }

    func formatAmountInPounds(_ amount: Double) -> String {
        return String.init(format: "£%.2f", amount)
    }
}
