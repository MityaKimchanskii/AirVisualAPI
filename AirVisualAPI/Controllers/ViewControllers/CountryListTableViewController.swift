//
//  CountryTableViewController.swift
//  AirVisualAPI
//
//  Created by Mitya Kim on 1/31/22.
//

import UIKit

class CountryListTableViewController: UITableViewController {

    
    // MARK: - Properties
    var countries: [String] = []
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCountries()
    }

    // MARK: - Helper Methods
    func fetchCountries() {
        AirQuolityController.fetchCountries { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let countries):
                    self.countries = countries
                    self.tableView.reloadData()
                case .failure(let error):
                    print(error)
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return countries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "countryCell", for: indexPath)
        
        let country = countries[indexPath.row]
        
        cell.textLabel?.text = country

        return cell
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toStateSegue" {
            guard let indexpath = tableView.indexPathForSelectedRow,
                  let destination = segue.destination as? StateListTableViewController else { return }
            
            let country = countries[indexpath.row]
            
            destination.country = country
        }
    }
}
