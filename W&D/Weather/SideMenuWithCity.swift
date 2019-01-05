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
            cell.id = city.id
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
        let cityId = appDelegate.allCities.filter({$0.name == cell.city.text}).first
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
     
     //new2
     
     func tableView(_ tableView: UITableView,
                    leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
     {
          let closeAction = UIContextualAction(style: .normal, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
               print("OK, marked as Closed")
               let cell = tableView.cellForRow(at: indexPath) as! AddedCitiesListCell
                         GetWeather.shared.deleteFromCoreData(id: cell.id)
               
               if self.appDelegate.currentCity.id == cell.id {
                    if !self.appDelegate.allCities.isEmpty {
                         self.appDelegate.allCities = self.self.appDelegate.allCities.filter({$0.id == cell.id})
                         self.appDelegate.currentCity = self.appDelegate.allCities[0]
                         self.appDelegate.currentWeather = self.appDelegate.currentWeather
                                   tableView.reloadData()
               
                              }
                         }
               UserDefaults.standard.set(self.appDelegate.currentCity.id, forKey: "CurrentCityId")
                         GetWeather.shared.fetchCoreData()
                         tableView.reloadData()
                         print("index \(indexPath.row)")
                         NotificationCenter.default.post(name: NSNotification.Name("ChangeCity"), object: nil)
               
               
               success(true)
          })
          closeAction.backgroundColor = .red
          
          return UISwipeActionsConfiguration(actions: [closeAction])
          
     }
     
     func tableView(_ tableView: UITableView,
                    trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
     {
          let modifyAction = UIContextualAction(style: .normal, title:  "Update", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
               print("Update action ...")
               success(true)
          })
//          modifyAction.image = UIImage(named: "hammer")
          modifyAction.backgroundColor = .blue
          
          return UISwipeActionsConfiguration(actions: [modifyAction])
     }
     
     
}
