//
//  BudgetCategory+CoreDataClass.swift
//  BudgetApp
//
//  Created by ByteDance on 26/05/25.
//

import Foundation
import CoreData

@objc(BudgetCategory)
public class BudgetCategory: NSManagedObject {
    
}

extension BudgetCategory {
    var transactionTotal: Double {
        
        let transactionsArray: [Transaction] = transactions?.toArray() ?? []
        return transactionsArray.reduce(0) { next, transaction in
            next + transaction.amount
        }
    }
    
    var remainingAmount: Double {
        amount - transactionTotal
    }
}
