//
//  AddOrderViewController.swift
//  Coffee-Maker
//
//  Created by JINSEOK on 2023/02/07.
//

import UIKit

protocol AddCoffeeOrderDelegate {
    func addCoffeeOrderViewControlletDidSave(_ controller: UIViewController, order: Order)
    func addCoffeeOrderViewControlletDidClose(_ controller: UIViewController)
}

class AddOrderViewController: UIViewController {
    
    var delegate: AddCoffeeOrderDelegate?
    
    private var viewModel = AddCoffeOrderViewModel()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextFiled: UITextField!
    private var coffeeSizeSegmentedControl: UISegmentedControl!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        coffeeSizeSegmentedControl = UISegmentedControl(items: self.viewModel.sizes)
        self.view.addSubview(coffeeSizeSegmentedControl)
        coffeeSizeSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            coffeeSizeSegmentedControl.topAnchor.constraint(equalTo: self.tableView.bottomAnchor, constant: 30),
            coffeeSizeSegmentedControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        let selectSize = self.coffeeSizeSegmentedControl.titleForSegment(at: self.coffeeSizeSegmentedControl.selectedSegmentIndex)
        
        guard let indexPath = self.tableView.indexPathForSelectedRow else {
            fatalError("Error in selecting Coffee")
        }
        
        self.viewModel.name = nameTextField.text
        self.viewModel.email = emailTextFiled.text
        self.viewModel.selcetedType = self.viewModel.types[indexPath.row]
        self.viewModel.selcetedSize = selectSize
        
        Task.detached {
            do {
                let order = try await Webservice().load(resource: Order.create(viewModel: self.viewModel))
                
                if let order = order, let delegate = await self.delegate {
                    
                    DispatchQueue.main.async {
                        delegate.addCoffeeOrderViewControlletDidSave(self, order: order)
                    }
                }
            } catch {
                print(error)
            }
        }
    }
    
    @IBAction func closeButtonTapped(_ sender: UIBarButtonItem) {
        if let delegate = self.delegate {
            delegate.addCoffeeOrderViewControlletDidClose(self)
        }
    }
    
}

extension AddOrderViewController: UITableViewDataSource {
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

extension AddOrderViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
}
