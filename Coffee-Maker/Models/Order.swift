//
//  Order.swift
//  Coffee-Maker
//
//  Created by JINSEOK on 2023/02/08.
//

import Foundation

enum CoffeeType: String, Codable, CaseIterable {
    case cappuccino
    case latte
    case espresso
    case longblack
}

enum CoffeeSize: String, Codable, CaseIterable {
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

extension Order {
    
    static var all: Resource<[Order]> = {
        
        guard let url = URL(string: "https://warp-wiry-rugby.glitch.me/orders") else {
            fatalError("URL is incorrect!")
        }
         return Resource<[Order]>(url: url)
    }()
    
    static func create(viewModel: AddCoffeOrderViewModel) -> Resource<Order?> {
        
        let order = Order(viewModel)
        
        guard let url = URL(string: "https://warp-wiry-rugby.glitch.me/orders") else {
            fatalError("URL is incorrect!")
        }
        
        guard let encodingData = try? JSONEncoder().encode(order) else {
            fatalError("Error Encoding Order")
        }
        
        var resource = Resource<Order?>(url: url)
        resource.hpptMethod = .post
        resource.body = encodingData
        
        return resource
    }
}

extension Order {
    
    init?(_ viewModel: AddCoffeOrderViewModel) {
        
        guard let name = viewModel.name,
              let email = viewModel.email,
              let selectedType = CoffeeType(rawValue: viewModel.selcetedType!.lowercased()),
              let selectedSize = CoffeeSize(rawValue: viewModel.selcetedSize!.lowercased()) else {
            return nil
        }
        
        self.name = name
        self.email = email
        self.type = selectedType
        self.size = selectedSize
    }
}
