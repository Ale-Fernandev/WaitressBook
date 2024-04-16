//
//  Tips.swift
//  WaitressBook
//
//  Created by  on 4/12/24.
//

import Foundation

class Tips {
    let table: Table
    let tipAmount: Double
    let timeStamp: Date
    
    init(table: Table, tipAmount: Double) {
        self.table = table
        self.tipAmount = tipAmount
        self.timeStamp = Date()
    }
}
