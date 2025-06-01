//
//  BudgetCategoriesTableViewController.swift
//  BudgetApp
//
//  Created by ByteDance on 26/05/25.
//

import UIKit
import CoreData

class BudgetCategoriesTableViewController: UITableViewController {
    // this is in charge of communicating with the data store
    private var persistentContainer: NSPersistentContainer
    
    // this is responsible of fetching the data
    private var fetchedResultsController: NSFetchedResultsController<BudgetCategory>!
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
        super.init(nibName: nil, bundle: nil)
        
        // needed to initialise the fetchResultsController
        let request = BudgetCategory.fetchRequest()
        // sort the result according to name in ascending order
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        // register cell
        tableView.register(BudgetTableViewCell.self, forCellReuseIdentifier: "BudgetTableViewCell")
    }
    
    @objc func showAddBudgetCategory(_ sender: UIBarButtonItem) {
        let navController = UINavigationController(rootViewController: AddBudgetCategoryViewController(persistentContainer: persistentContainer))
        present(navController, animated: true)
    }
    
    private func setupUI() {
        // this is the top right button at the navigation bar
        let addBudgetCategoryButton = UIBarButtonItem(title: "Add Category", style: .done, target: self, action: #selector(showAddBudgetCategory))
        // i can access navigationItem as BudgetCategoriesTableViewController is within the navigation tab
        self.navigationItem.rightBarButtonItem = addBudgetCategoryButton
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Budget"
    }
    
    // UITableViewDataSource delegate functions
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (fetchedResultsController.fetchedObjects ?? []).count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let budgetCategory = fetchedResultsController.object(at: indexPath)
        // perform navigation
        self.navigationController?.pushViewController(BudgetDetailViewController(budgetCategory: budgetCategory, persistentContainer: persistentContainer), animated: true)
        
    }
    
    private func deleteBudgetCategory(_ budgetCategory: BudgetCategory) {
        
        persistentContainer.viewContext.delete(budgetCategory)
        do {
            try persistentContainer.viewContext.save()
        } catch {
           showAlert(title: "Error", message: "Unable to save budget category.")
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let budgetCategory = fetchedResultsController.object(at: indexPath)
            deleteBudgetCategory(budgetCategory)
            
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BudgetTableViewCell", for: indexPath) as? BudgetTableViewCell else {
            return BudgetTableViewCell(style: .default, reuseIdentifier: "BudgetTableViewCell")
        }
        
        cell.accessoryType = .disclosureIndicator
        
        
        let budgetCategory = fetchedResultsController.object(at: indexPath)
        cell.configure(budgetCategory)
        return cell
    }

}

extension BudgetCategoriesTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
    
}
