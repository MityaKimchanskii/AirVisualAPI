//
//  DetailViewController.swift
//  AirVisualAPI
//
//  Created by Mitya Kim on 1/31/22.
//

import UIKit

class DetailViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var cityStateCountryLabel: UILabel!
    @IBOutlet weak var aqiLabel: UILabel!
    @IBOutlet weak var wsLabel: UILabel!
    @IBOutlet weak var tpLabel: UILabel!
    @IBOutlet weak var huLabel: UILabel!
    @IBOutlet weak var latLongLabel: UILabel!
    
    
    // MARK: - Properties
    var country: String?
    var state: String?
    var city: String?
    

    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }
    
    // MARK: - Helper Methods
    func fetchData() {
        guard let city = city, let state = state, let country = country else { return }
        AirQuolityController.fetchData(forCity: city, inState: state, inCountry: country) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let cityData):
                    self.updateView(with: cityData)
                case .failure(let error):
                    print(error)
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func updateView(with cityData: CityData) {
        let data = cityData.data
        
        cityStateCountryLabel.text = "\(data.country), \(data.state), \(data.city)"
        aqiLabel.text = "AQI: \(data.current.pollution.aqius)"
        wsLabel.text = "Windspeed: \(data.current.weather.ws)"
        tpLabel.text = "Temperature: \(data.current.weather.tp)"
        huLabel.text = "Human: \(data.current.weather.hu)"
        
        let coordinates = data.location.coordinates
        if coordinates.count == 2 {
            
            latLongLabel.text = "longitude: \(coordinates[0]), latitude: \(coordinates[1])"
        } else {
            latLongLabel.text = "Hello, World!"
        }
    }
}
