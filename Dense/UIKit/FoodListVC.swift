//
//  FirstViewController.swift
//  Food Weight Calculator
//
//  Created by Joseph Pecoraro on 8/23/19.
//  Copyright © 2019 Joseph Pecoraro. All rights reserved.
//

import UIKit

class FoodListVC : UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var calsPerOzLabel: UILabel!
    
    @IBOutlet weak var calsPerDayTextField: UITextField!
    @IBOutlet weak var daysOfFoodLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    let formatter = NumberFormatter()
    
    var caloriesPerDay : Double = 0
    
    var food : [FoodItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        
        setupNavBar()
        
        loadFromUserDefaults()
        commitChange()
        loadFood()
    }
    
    func setupNavBar() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clearAll))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAddFoodAlert))
    }

    func loadFromUserDefaults() {
        UserDefaults.standard.register(defaults: ["calsPerDay" : 3000.0])
        
        caloriesPerDay = UserDefaults.standard.double(forKey: "calsPerDay")
    }
    
    func loadFood() {
        Task {
            self.food = await dataAccessor.food()
            
            DispatchQueue.main.async {
                self.commitChange()
            }
        }
    }
    
    func saveToUserDefaults() {
        UserDefaults.standard.set(caloriesPerDay, forKey: "calsPerDay")
    }
    
    func calculate() {
        let foodCalculator = FoodCalculator(foodList: food)
        let weight = foodCalculator.weight()
        let calories = foodCalculator.calories()
        
        self.caloriesLabel.text = formatter.string(from: calories)
        self.weightLabel.text = getLabel(weight: weight)
        self.calsPerOzLabel.text = formatter.string(from: calories/weight)
        
        self.calsPerDayTextField.text = formatter.string(from: caloriesPerDay)
        self.daysOfFoodLabel.text = formatter.string(from: calories/caloriesPerDay)
    }
    
    func getLabel(weight: Double) -> String {
        if weight < 16 {
            return "\(formatter.string(from: weight) ?? "0")oz"
        }
        
        let oz = weight.truncatingRemainder(dividingBy: 16)
        let lbs = (weight - oz)/16
        
        return "\(formatter.string(from: lbs) ?? "0")lbs \(formatter.string(from: oz) ?? "0")oz"
    }
    
    @IBAction func textDidChange(_ sender: UITextField) {
        caloriesPerDay = Double(sender.text ?? "") ?? 0
        saveToUserDefaults()
        calculate()
    }
    
    
    @objc func clearAll() {
        let alertController = UIAlertController(title: "Clear all food?", message: "Are you sure you want to clear all the items in the list?", preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction) in }
        
        let clear = UIAlertAction(title: "Clear All", style: .destructive) { (action:UIAlertAction) in
            self.food = dataAccessor.clearFood()
            self.commitChange()
        }
        
        alertController.addAction(cancel)
        alertController.addAction(clear)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func showAddFoodAlert() {
        let alertController = UIAlertController(title: "Add Some Food", message: nil, preferredStyle: .alert)
        
        let addFoodAction = UIAlertAction(title: "Add Food", style: .default) { (_) in
            let nameTextField = alertController.textFields![0] as UITextField
            let caloriesPerServingTextField = alertController.textFields![1] as UITextField
            let numberOfServingsTextField = alertController.textFields![2] as UITextField
            let weightTextField = alertController.textFields![3] as UITextField
            
            self.addFood(name: nameTextField.text, calories: caloriesPerServingTextField.text, servings: numberOfServingsTextField.text, weight: weightTextField.text)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
    
        alertController.addTextField { (textField) in
            textField.placeholder = "Name"
            textField.keyboardType = .default
        }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Calories Per Serving"
            textField.keyboardType = .decimalPad
        }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Number of Servings"
            textField.keyboardType = .decimalPad
        }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Net Weight (Oz)"
            textField.keyboardType = .decimalPad
        }
        
        alertController.addAction(addFoodAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func addFood(name: String?, calories: String?, servings: String?, weight: String?) {
        let totalCalories = (Double(calories ?? "") ?? 0) * (Double(servings ?? "") ?? 1)
        let newFood = FoodItem(name: name ?? "", calories: totalCalories, oz: Double(weight ?? "") ?? 0)
        
        food = dataAccessor.addFood(food: newFood)
        commitChange()
    }
    
    func commitChange() {
        calculate()
        saveToUserDefaults()
        tableView.reloadData()
    }
    
    // MARK - TableView Data Source/Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return food.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodCell", for: indexPath)
        
        let foodItem = food[indexPath.row]
        
        cell.textLabel?.text = "\(foodItem.name) - \(formatter.string(from: foodItem.calories/foodItem.oz) ?? "") Cals/Oz"
        cell.detailTextLabel?.text = "Calories: \(formatter.string(from: foodItem.calories) ?? "") Weight \(formatter.string(from: foodItem.oz) ?? "")oz"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            self.food = dataAccessor.removeFood(index: indexPath.row)
            commitChange()
        }
    }
}

