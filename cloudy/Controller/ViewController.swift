//
//  ViewController.swift
//  cloudy
//
//  Created by Artsiom Sadyryn on 3/2/18.
//  Copyright © 2018 Artsiom Sadyryn. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CityDelegate {
    
    
    //MARK: Properties
    
    @IBOutlet weak var weatherTable: UITableView!
    var weatherInCityArr = [City]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        weatherTable.dataSource = self
        weatherTable.delegate = self
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.updateCityTable), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        if let filepath = Bundle.main.path(forResource: "cityList", ofType: "json") {
            do {
                let json = try String(contentsOfFile: filepath)
                
                if let data = json.data(using: .utf8) {
                    if let json = try? JSON(data: data) {
                        for item in json["City"].arrayValue {
                            if let cityName = item.rawString() {
                                let newCity = City(city: cityName)
                                weatherInCityArr.append(newCity)
                                newCity.getWeatherInfo()
                                newCity.delegate = self
                            }
                        }
                    }
                }
                
            } catch {
                // contents could not be loaded
            }
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Table View Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherInCityArr.count
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        weatherTable.reloadData()
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "CityTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CityTableViewCell  else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let weatherInCity = weatherInCityArr[indexPath.row]
        
        cell.cityNameLabel.text = weatherInCity.cityName
        
            if weatherInCity.failed == false {
                cell.temperatureLabel.text = weatherInCity.temperature
            }
            else {
                cell.temperatureLabel.text = "-"
                cell.temperatureLabel.textColor = .red
            }
        
        return cell
    }
    
    //MARK: Delegate Methods
    
    @objc func updateCityTable() {
        weatherTable.reloadData()
    }
    
}
