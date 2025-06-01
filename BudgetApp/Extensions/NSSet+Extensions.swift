//
//  NSSet+Extensions.swift
//  BudgetApp
//
//  Created by ByteDance on 26/05/25.
//

import Foundation

extension NSSet {
    
    func toArray<T>() -> [T] {
        let array = self.map { $0 as! T}
        return array
    }
    
}
