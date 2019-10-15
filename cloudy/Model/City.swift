//
//  DataRecivier.swift
//  cloudy
//
//  Created by Artsiom Sadyryn on 3/2/18.
//  Copyright © 2018 Artsiom Sadyryn. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol CityDelegate: class {
    func updateCityTable()
}

class City {
    
    let cityName: String
    var temperature: String?
    var pressure: String?
    var humidity: String?
    var failed: Bool
    weak var delegate: CityDelegate?
    
    init(city: String) {
        self.cityName = city
        self.temperature = "-"
        self.pressure = "-"
        self.humidity = "-"
        self.failed = false
    }
    
    func getWeatherInfo() {
        
        let weather = WeatherGetter()
        
        weather.getWeather(city: cityName, completion: { (weatherInCity) in
            guard let weatherInCity = weatherInCity else {
                self.failed = true
                return
            }
            
            if let data = weatherInCity.data(using: .utf8) {
                if let json = try? JSON(data: data) {
                    if let temperature = json["main"]["temp"].int {
                        self.temperature = String(temperature)
                        self.delegate?.updateCityTable()
                    }
                    if let pressure = json["main"]["pressure"].int {
                        self.pressure = String(pressure)
                        
                    }
                    if let humidity = json["main"]["humidity"].int {
                        self.humidity = String(humidity)
                        
                    }
                }
            }
        })
    }
}



