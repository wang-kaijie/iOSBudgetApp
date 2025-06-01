//
//  Double+Extensions.swift
//  BudgetApp
//
//  Created by ByteDance on 26/05/25.
//

import Foundation

extension Double {
    
    func formatAsCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: self)) ?? "0.00"
    }
    
}
