//
//  StateTableViewController.swift
//  AirVisualAPI
//
//  Created by Mitya Kim on 1/31/22.
//

import UIKit

class StateListTableViewController: UITableViewController {

    // MARK: - Properties
    var country: String?
    var states: [String] = []
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchStates()
    }

    // MARK: - Helper Methods
    func fetchStates() {
        guard let country = country else { return }
        AirQuolityController.fetchStates(forCountry: country) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let states):
                    self.states = states
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
        
        return states.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stateCell", for: indexPath)

        let state = states[indexPath.row]
        
        cell.textLabel?.text = state

        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCitySegue" {
            guard let indexpath = tableView.indexPathForSelectedRow,
                  let destination = segue.destination as? CityListTableViewController else { return }
            
            let state = states[indexpath.row]
            
            destination.country = country
            destination.state = state
        }
    }
    

}
