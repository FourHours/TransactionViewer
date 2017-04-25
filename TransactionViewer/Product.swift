//
//  Product.swift
//  TransactionViewer
//
//  Created by Q Zhuang on 4/25/17.
//  Copyright © 2017 Q Zhuang. All rights reserved.
//

import Foundation

struct Transaction {
    var amount: Double
    var currency: String
    var amountInPounds: Double
}

struct Product {
    var sku: String
    var transactions: [Transaction]
}

struct Element {
    var sku: String
    var currency: String
    var amount: Double
    
    init(dic: Dictionary<String, Any>) {
        if let skuValue = dic["sku"] {
            sku = skuValue as! String
        }
        else {
            sku = ""
        }
        
        if let currencyValue = dic["currency"] {
            currency = currencyValue as! String
        }
        else {
            currency = ""
        }
        
        if let amountValue = dic["amount"], let value = Double(amountValue as! String) {
            amount = value
        }
        else {
            amount = 0.0
        }
    }
}
