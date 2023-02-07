//
//  OrdersTableViewController.swift
//  Coffee-Maker
//
//  Created by JINSEOK on 2023/02/07.
//

import UIKit

class OrdersTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task.detached {
            await self.populateOrders()
        }
    }
    
    private func populateOrders() async {
        guard let coffeeOrdersURL = URL(string: "https://warp-wiry-rugby.glitch.me/orders") else {
            fatalError("URL was incorrect")
        }
        
        let resource = Resource<[Order]>(url: coffeeOrdersURL)
        
        do {
            let result = try await Webservice().load(resource: resource)
            print(result)
        } catch {
            print(error)
        }
    }
}
