//
//  AddCoffeOrderViewModel.swift
//  Coffee-Maker
//
//  Created by JINSEOK on 2023/02/08.
//

import Foundation

struct AddCoffeOrderViewModel {
    
    var name: String?
    var email: String?
    var selcetedType: String?
    var selcetedSize: String?
    
    var types: [String] {
        return CoffeeType.allCases.map { $0.rawValue.capitalized }
    }
    
    var sizes: [String] {
        return CoffeeSize.allCases.map { $0.rawValue.capitalized }
    }
}

extension AddOrderViewController {
    
    
}
