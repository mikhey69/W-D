//
//  SideMenu.swift
//  W&D
//
//  Created by softevol on 12/28/18.
//  Copyright © 2018 mikhey. All rights reserved.
//

import Foundation
import UIKit

class SideMenuWithCity: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var temp: UILabel!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if appDelegate.currentCity != nil {
            city.text = appDelegate.currentCity.name
            let weather = appDelegate.currentCity.weather?[0]
            temp.text = String(Int((weather?.temp ?? 0) - 273.15)) + "°C"
        }
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        tableView.reloadData()
    }
    
    @IBAction func addCity(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: NSNotification.Name("addCity"), object: nil)
    }
}

extension SideMenuWithCity {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.allCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityInfo", for: indexPath) as! AddedCitiesListCell
        if !appDelegate.allCities.isEmpty {
            let city = appDelegate.allCities[indexPath.row]
            let weather = city.weather?[0]
            cell.city.text = city.name
            cell.country.text = city.country
            cell.temp.text = String(Int((weather?.temp ?? 0) - 273.15)) + "°"
            cell.imgView.image = Function.shared.getWeatherIcon(name: weather?.icon ?? "01d")
            if appDelegate.currentCity != nil {
                if appDelegate.currentCity.name != cell.city.text {
                    cell.SelectedCity.isHidden = true
                } else {
                    cell.SelectedCity.isHidden = false
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! AddedCitiesListCell
        var cityId = appDelegate.allCities.filter({$0.name == cell.city.text}).first
        UserDefaults.standard.set(cityId?.id, forKey: "CurrentCityId")
        appDelegate.currentCity = cityId
        city.text = appDelegate.currentCity.name
        let weather = appDelegate.currentWeather
        temp.text = String(Int((weather?.temp ?? 0) - 273.15)) + "°"
        //save to userDefaults
        
        NotificationCenter.default.post(name: NSNotification.Name("ChangeCity"), object: nil)
        tableView.reloadData()
        self.dismiss(animated: true, completion: nil)
        
    }
}
