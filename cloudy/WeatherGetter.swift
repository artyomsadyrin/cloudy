//
//  WeatherGetter.swift
//  cloudy
//
//  Created by Artsiom Sadyryn on 3/2/18.
//  Copyright © 2018 Artsiom Sadyryn. All rights reserved.
//

import Foundation
import SwiftyJSON

class WeatherGetter {
    
    private let openWeatherMapBaseURL = "https://api.openweathermap.org/data/2.5/weather"
    private let openWeatherMapAPIKey = "YOUR_API"
    
    func getWeather(city: String, completion: @escaping (String?) -> Void) {
        
        var dataString = String()
        
        //http://api.openweathermap.org/data/2.5/weather?q=Moscow&APPID=3e8ec8b8acd3ff0014e3e1530afac8a3
        
        let replacedCity = city.replacingOccurrences(of: " ", with: "%20")
        
        // This is a pretty simple networking task, so the shared session will do.
        let session = URLSession.shared
        
        let weatherRequestURL = URL(string: "\(openWeatherMapBaseURL)?q=\(replacedCity)&APPID=\(openWeatherMapAPIKey)")!
        
        // The data task retrieves the data.
        let dataTask = session.dataTask(with: weatherRequestURL) {
            (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                // Case 1: Error
                // We got some kind of error while trying to get data from the server.
                print("Error:\n\(error)")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
            else {
                // Case 2: Success
                // We got a response from the server!
                    dataString = String(data: data!, encoding: String.Encoding.utf8)!
                    print("Human-readable data:\n\(dataString)")
                    DispatchQueue.main.async {
                        completion(dataString)
                    }
                }
            
            }
        
        // The data task is set up...launch it!
        dataTask.resume()
    }
}
