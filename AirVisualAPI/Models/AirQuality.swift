//
//  AirQuality.swift
//  AirVisualAPI
//
//  Created by Mitya Kim on 1/31/22.
//

import Foundation

struct Country: Codable {
    
    let data: [Data]
    
    struct Data: Codable {
        let countryName: String
        
        enum CodingKeys: String, CodingKey {
            case countryName = "country"
        }
    }
}

struct State: Codable {
    let data: [Data]
    
    struct Data: Codable {
        let stateName: String

        enum CodingKeys: String, CodingKey {
            case stateName = "state"
        }
    }
}

struct City: Codable {
    let data: [Data]
    
    struct Data: Codable {
        let cityName: String
        
        enum CodingKeys: String, CodingKey {
            case cityName = "city"
        }
    }
}

struct CityData: Codable {
    let data: Data
    
    struct Data: Codable {
        let city: String
        let state: String
        let country: String
        
        let location: Location
        struct Location: Codable {
            let coordinates: [Double]
        }
        
        let current: Current
        struct Current: Codable {
            let weather: Weather
            struct Weather: Codable {
                let tp: Int
                let hu: Int
                let ws:Double
            }
            
            let pollution: Pollution
            struct Pollution: Codable {
                let aqius: Int
            }
        }
    }
}
