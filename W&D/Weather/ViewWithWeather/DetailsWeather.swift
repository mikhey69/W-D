//
//  DetailsWeather.swift
//  W&D
//
//  Created by softevol on 12/28/18.
//  Copyright © 2018 mikhey. All rights reserved.
//

import Foundation
import UIKit
import SideMenu

class DetailsWeather: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var imgVIew: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var realFeel: UILabel!
    
    @IBOutlet weak var temp: UILabel!
    
    var weather: Weather!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if weather != nil {
            name.text = weather.weatherName
            temp.text = String(Int((weather.temp ?? 0) - 273.15)) + "°c"
            realFeel.text = String(Int((weather.temp ?? 0) - 273.15)) + "°c"
            imgVIew.image = Function.shared.getWeatherIcon(name: weather.icon ?? "")
        }
    }
}

extension DetailsWeather {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailsCell", for: indexPath
        ) as! DetailsCell
        
        if weather != nil {
            if indexPath.row == 0 {
                cell.name.text = "humidity"
                cell.valueLbl.text = String(Int(weather.humidity ?? 0)) + " hpa"
            } else if indexPath.row == 1 {
                cell.name.text = "Wind Speed"
                cell.valueLbl.text = String(Int(weather.windSpeed ?? 0)) + "%"
            } else if indexPath.row == 2 {
                cell.name.text = "Pressure"
                cell.valueLbl.text =  String(Int(weather.pressure ?? 0)) + " m/s"
            }
        }
        
        return cell
    }
    
}
