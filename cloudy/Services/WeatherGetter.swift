//
//  WeatherGetter.swift
//  cloudy
//
//  Created by Artsiom Sadyryn on 3/2/18.
//  Copyright © 2018 Artsiom Sadyryn. All rights reserved.
//

import Foundation

class WeatherGetter {
    
    private let openWeatherMapBaseURL = "https://api.openweathermap.org/data/2.5/weather"
    #error("Need to add you API Key")
    private let openWeatherMapAPIKey = ""
    
    func getWeather(city: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        var dataString = String()
        
        let replacedCity = city.replacingOccurrences(of: " ", with: "%20")
        
        let session = URLSession.shared
        
        let weatherRequestURL = URL(string: "\(openWeatherMapBaseURL)?q=\(replacedCity)&APPID=\(openWeatherMapAPIKey)")!
        
        let dataTask = session.dataTask(with: weatherRequestURL) {
            (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                print("Error:\n\(error)")
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
            else {
                dataString = String(data: data!, encoding: String.Encoding.utf8)!
                print("Human-readable data:\n\(dataString)")
                DispatchQueue.main.async {
                    completion(.success(dataString))
                }
            }
            
        }
        dataTask.resume()
    }
}
