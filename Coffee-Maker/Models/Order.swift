//
//  Order.swift
//  Coffee-Maker
//
//  Created by JINSEOK on 2023/02/08.
//

import Foundation

enum CoffeeType: String, Codable {
    case cappuccino
    case lattee
    case espresso
    case longBlack
}

enum CoffeeSize: String, Codable {
    case small
    case medium
    case large
}

struct Order: Codable {
    let name: String
    let email: String
    let type: CoffeeType
    let size: CoffeeSize
}

