//
//  StatisticsModel.swift
//  CryptoApp
//
//  Created by Abduljamil SwiftCoder on 17/09/22.
//

import Foundation

struct StatisticsModel: Identifiable{
    let id = UUID().uuidString
    let title: String
    let value: String
    let percentageChange: Double?
    
    init(title: String, value: String, percentageChange: Double? = nil){
        self.value = value
        self.title = title
        self.percentageChange = percentageChange
    }
    
}
