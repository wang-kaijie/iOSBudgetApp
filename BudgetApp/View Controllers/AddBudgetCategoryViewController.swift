//
//  AddBudgetCategoryViewController.swift
//  BudgetApp
//
//  Created by ByteDance on 26/05/25.
//

import Foundation
import UIKit
import CoreData

class AddBudgetCategoryViewController: UIViewController {
    
    private var persistentContainer: NSPersistentContainer
    
    lazy var nameTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Budget name"
        textfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textfield.leftViewMode = .always
        textfield.borderStyle = .roundedRect
        return textfield
    }()
    
    lazy var amountTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Budget amount"
        textfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textfield.leftViewMode = .always
        textfield.borderStyle = .roundedRect
        return textfield
    }()
    
    lazy var addBudgetButton: UIButton = {
        
        var config = UIButton.Configuration.bordered()
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Save", for: .normal)
        return button
      
    }()
    
    lazy var errorMessageLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.red
        label.text = ""
        label.numberOfLines = 0
        return label
    }()
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Add Budget"
        setupUI()
    }
    
    private var isFormValid: Bool {
        guard let name = nameTextField.text, let amount = amountTextField.text else {
            return false
        }
        
        return !name.isEmpty && !amount.isEmpty && amount.isNumeric && amount.isGreatorThan(0)
    }
    
    private func saveBudgetCategory() {
        
        guard let name = nameTextField.text, let amount = amountTextField.text else {
            return
        }
        
        do {
            // create an instance tied to the context
            let budgetCategory = BudgetCategory(context: persistentContainer.viewContext)
            budgetCategory.name = name
            budgetCategory.amount = Double(amount) ?? 0.0
            // context saves changes according to model definitions
            try persistentContainer.viewContext.save()
            // dismiss the modal
            dismiss(animated: true)
        } catch {
            errorMessageLabel.text = "Unable to save budget category."
        }
        
    }
    
    @objc func addBudgetButtonPressed(_ sender: UIButton) {
        if isFormValid {
            saveBudgetCategory()
        } else {
            errorMessageLabel.text = "Unable to save budget. Budget name and amount is required."
        }
    }
    
    private func setupUI() {
        
        let stackView = UIStackView()
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = UIStackView.spacingUseSystem
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(nameTextField)
        stackView.addArrangedSubview(amountTextField)
        stackView.addArrangedSubview(addBudgetButton)
        stackView.addArrangedSubview(errorMessageLabel)
        
        // add constraints
        nameTextField.widthAnchor.constraint(equalToConstant: 300).isActive = true
        amountTextField.widthAnchor.constraint(equalToConstant: 300).isActive = true
        addBudgetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        // add button click
        addBudgetButton.addTarget(self, action: #selector(addBudgetButtonPressed), for: .touchUpInside)
        
        stackView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        // The constraint aligns the horizontal center of `stackView` with the horizontal center of `view`, effectively centering the stack view horizontally inside the view.
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
}
