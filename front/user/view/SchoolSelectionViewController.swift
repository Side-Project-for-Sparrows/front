//
//  SchoolSelectionViewController.swift
//  front
//
//  Created by 정예은 on 6/14/25.
//

import UIKit

class SchoolSelectionViewController: UITableViewController, UISearchBarDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet weak var searchTextField: UISearchBar!
    
    
    // MARK: - Properties
    private let viewModel = SchoolSelectionViewModel()
    private var schools: [School] = []
    private var selectedSchool: School?
    
    // MARK: - Callback
    var onSchoolSelected: ((School) -> Void)?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    // MARK: - Setup
    private func setupUI() {
        title = "학교 선택"
        searchTextField.delegate = self
    }
    
    private func bindViewModel() {
        viewModel.onSchoolSearchSuccess = { [weak self] schools in
            self?.schools = schools
            self?.tableView.reloadData()
        }
        
        viewModel.onSchoolSearchFailure = { [weak self] errorMessage in
            self?.showToast(message: errorMessage)
        }
    }
    
    // MARK: - UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchSchools(query: searchText)
    }
    
    // MARK: - TableView DataSource & Delegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schools.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SchoolCell", for: indexPath)
        let school = schools[indexPath.row]
        cell.textLabel?.text = school.name
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = schools[indexPath.row]
        onSchoolSelected?(selected)
        self.dismiss(animated: true)
    }
    
    // MARK: - Helper Methods
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension SchoolSelectionViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
} 
