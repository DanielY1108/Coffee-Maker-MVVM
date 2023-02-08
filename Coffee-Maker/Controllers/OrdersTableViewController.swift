//
//  OrdersTableViewController.swift
//  Coffee-Maker
//
//  Created by JINSEOK on 2023/02/07.
//

import UIKit

class OrdersTableViewController: UITableViewController {
    
    var orderListViewModel = OrderListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task.detached {
            await self.populateOrders()
        }
    }
    
    private func populateOrders() async {
        
        do {
            let orders = try await Webservice().load(resource: Order.all)
            orderListViewModel.ordersViewModel = orders.map(OrderViewModel.init)
            
            self.tableView.reloadData()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let navigationC = segue.destination as? UINavigationController,
              let addCoffeeOrderVC = navigationC.viewControllers.first as? AddOrderViewController else {
            fatalError("Error performing segeu!")
        }
        addCoffeeOrderVC.delegate = self
    }
}

extension OrdersTableViewController: AddCoffeeOrderDelegate {
    func addCoffeeOrderViewControlletDidSave(_ controller: UIViewController, order: Order) {
        controller.dismiss(animated: true)
        
        let orderVM = OrderViewModel(order: order)
        self.orderListViewModel.ordersViewModel.append(orderVM)
        self.tableView.insertRows(at: [IndexPath.init(row: self.orderListViewModel.ordersViewModel.count - 1, section: 0)], with: .automatic)
    }
    
    func addCoffeeOrderViewControlletDidClose(_ controller: UIViewController) {
        controller.dismiss(animated: true)
    }
}

extension OrdersTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        orderListViewModel.ordersViewModel.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = self.orderListViewModel.orderViewModel(at: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTableViewCell", for: indexPath)
        
        cell.textLabel?.text = viewModel.type
        cell.detailTextLabel?.text = viewModel.size
        
        return cell
    }
}
