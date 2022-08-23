//
//  Currency.swift
//  currency_converter
//
//  Created by Leonid on 14.08.2022.
//

import Foundation

struct CurrencyData : Codable {
    let query : Query
    let result : Double
}

struct Query : Codable {
    let from : String
    let to : String
    let amount : Double
}

