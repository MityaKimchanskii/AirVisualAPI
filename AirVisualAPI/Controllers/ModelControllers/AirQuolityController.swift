//
//  AirQuolityController.swift
//  AirVisualAPI
//
//  Created by Mitya Kim on 1/31/22.
//

import Foundation
import UIKit

class AirQuolityController {
    
    // MARK: - String Constants
    static let baseURL = URL(string: "https://api.airvisual.com")
    static let versionComponent = "v2"
    static let countriesComponent = "countries"
    static let statesComponent = "states"
    static let citiesComponent = "cities"
    static let cityComponent = "city"
    
    static let countryKey = "country"
    static let stateKey = "state"
    static let cityKey = "city"
    static let apiKeyKey = "key"
    static let apiKeyValye = "4b7bba66-2467-4599-a8fb-e07261a2366c"
    
    // MARK: - Countries http://api.airvisual.com/v2/countries?key={{YOUR_API_KEY}}
    static func fetchCountries(completion: @escaping (Result<[String], NetworkError>) -> Void) {
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL)) }
        let versionURL = baseURL.appendingPathComponent(versionComponent)
        let countriesURL = versionURL.appendingPathComponent(countriesComponent)
        
        var components = URLComponents(url: countriesURL, resolvingAgainstBaseURL: true)
        let apiQuery = URLQueryItem(name: apiKeyKey, value: apiKeyValye)
        components?.queryItems = [apiQuery]
        
        guard let finalURL = components?.url else { return completion(.failure(.invalidURL)) }
        
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { data, _, error in
            
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else { return completion(.failure(.noData)) }
            
            do {
                let topLevelObject = try JSONDecoder().decode(Country.self, from: data)
                let countryDics = topLevelObject.data
                
                var listOfCountryNames: [String] = []
                
                for country in countryDics {
                    let countryName = country.countryName
                    listOfCountryNames.append(countryName)
                }
                return completion(.success(listOfCountryNames))
                
            } catch {
                return completion(.failure(.unableToDecode))
            }
        }.resume()
    }

    // MARK: - States http://api.airvisual.com/v2/states?country={{COUNTRY_NAME}}&key={{YOUR_API_KEY}}
    
    static func fetchStates(forCountry: String, completion: @escaping (Result<[String], NetworkError>) -> Void) {
        guard let baseUrl = baseURL else { return completion(.failure(.invalidURL)) }
        let versionURL = baseUrl.appendingPathComponent(versionComponent)
        let stateURL = versionURL.appendingPathComponent(statesComponent)
        
        var components = URLComponents(url: stateURL, resolvingAgainstBaseURL: true)
        let countryQuery = URLQueryItem(name: countryKey, value: forCountry)
        let apiQuery = URLQueryItem(name: apiKeyKey, value: apiKeyValye)
        components?.queryItems = [countryQuery, apiQuery]
        
        guard let finalURL = components?.url else { return completion(.failure(.invalidURL)) }
        
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { data, _, error in

            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else { return completion(.failure(.noData)) }
            
            do {
                let topLevelObject = try JSONDecoder().decode(State.self, from: data)
                let statesDicts = topLevelObject.data
                
                var listOfStateName: [String] = []
                
                for state in statesDicts {
                    let stateName = state.stateName
                    listOfStateName.append(stateName)
                }
                
                return completion(.success(listOfStateName))
                
            } catch {
                return completion(.failure(.unableToDecode))
            }
        }.resume()
    }
    
    // MARK: - City http://api.airvisual.com/v2/cities?state={{STATE_NAME}}&country={{COUNTRY_NAME}}&key={{YOUR_API_KEY}}
    static func fetchCities(forState: String, inCountry: String, completion: @escaping (Result<[String], NetworkError>) -> Void) {
        
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL)) }
        let versionURL = baseURL.appendingPathComponent(versionComponent)
        let citiesURL = versionURL.appendingPathComponent(citiesComponent)
        
        var components = URLComponents(url: citiesURL, resolvingAgainstBaseURL: true)
        let stateQuery = URLQueryItem(name: stateKey, value: forState)
        let countryQuery = URLQueryItem(name: countryKey, value: inCountry)
        let apiQuery = URLQueryItem(name: apiKeyKey, value: apiKeyValye)
        components?.queryItems = [stateQuery, countryQuery, apiQuery]
        
        guard let finalURL = components?.url else { return completion(.failure(.invalidURL)) }
        
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { data, _, error in
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else { return completion(.failure(.noData)) }
            
            do {
                let topLevelObject = try JSONDecoder().decode(City.self, from: data)
                let cityDicts = topLevelObject.data
                
                var listOfCityNames: [String] = []
                
                for city in cityDicts {
                    let cityName = city.cityName
                    listOfCityNames.append(cityName)
                }
                
                return completion(.success(listOfCityNames))
                
            } catch {
                return completion(.failure(.unableToDecode))
            }

        }.resume()
    }
    
    // MARK: - City data https://api.airvisual.com/v2/city?city=Los Angeles&state=California&country=USA&key={{YOUR_API_KEY}}
    //https://api.airvisual.com/v2/city?city=Alamo&state=California&country=USA&key=4b7bba66-2467-4599-a8fb-e07261a2366c
    static func fetchData(forCity: String, inState: String, inCountry: String, completion: @escaping (Result<CityData, NetworkError>) -> Void) {
    
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL)) }
        let versionURL = baseURL.appendingPathComponent(versionComponent)
        let cityURL = versionURL.appendingPathComponent(cityComponent)
        //https://api.airvisual.com/v2/city?
        
        var components = URLComponents(url: cityURL, resolvingAgainstBaseURL: true)
        
        let cityQuery = URLQueryItem(name: cityKey, value: forCity)
        let stateQuery = URLQueryItem(name: stateKey, value: inState)
        let countryQuery = URLQueryItem(name: countryKey, value: inCountry)
        let apiQuery = URLQueryItem(name: apiKeyKey, value: apiKeyValye)
        components?.queryItems = [cityQuery, stateQuery, countryQuery, apiQuery]
        
        guard let finalURL = components?.url else { return completion(.failure(.invalidURL)) }

        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { data, _, error in
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else { return completion(.failure(.noData)) }
            
            do {
                let cityData = try JSONDecoder().decode(CityData.self, from: data)
                return completion(.success(cityData))
            } catch {
                return completion(.failure(.unableToDecode))
            }
        }.resume()
    }
}
