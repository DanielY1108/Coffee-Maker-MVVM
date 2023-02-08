//
//  AddOrderViewController.swift
//  Coffee-Maker
//
//  Created by JINSEOK on 2023/02/07.
//

import UIKit

class AddOrderViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel = AddCoffeOrderViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
    }

    @IBAction func closeButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }

}

extension AddOrderViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.types.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoffeeTypeTableViewCell", for: indexPath)
        
        cell.textLabel?.text = self.viewModel.types[indexPath.row]
        
        return cell
    }
    
    
}
