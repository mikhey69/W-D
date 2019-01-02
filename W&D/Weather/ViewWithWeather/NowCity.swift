//
//  AllCities.swift
//  weather
//
//  Created by mikhey on 12/24/18.
//  Copyright © 2018 mikhey. All rights reserved.
//

import UIKit
import GoogleMobileAds

class NowCity: UIViewController {
    
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    
    //date
    var date = Date()
    var calendar = Calendar.current
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        //current City
        NotificationCenter.default.addObserver(self, selector: #selector(self.changeCity), name: NSNotification.Name("ChangeCity"), object: nil)
        
        appDelegate.pageControlHight = pageControl.frame
        pageControl.currentPageIndicatorTintColor = UIColor.black
        pageControl.pageIndicatorTintColor = UIColor.black
        
        
        //load Ad
        bannerView.adUnitID = "ca-app-pub-6849226060302158/9737223213"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        self.tabBarController?.tabBar.tintColor = UIColor(red: 255/255, green: 133/255, blue: 255/255, alpha: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        date = Date()
        calendar = Calendar.current
        Function.shared.timeUpdate()
        if appDelegate.currentCity != nil {
            city.text = appDelegate.currentCity.name
        }
        tableView.reloadData()
    }
    
    override func viewWillLayoutSubviews() {
        tableView.reloadData()
        appDelegate.pageControlHight = pageControl.frame
        NotificationCenter.default.post(name: NSNotification.Name("addPoints"), object: nil)
    }
    
    @objc func changeCity() {
        print("done")
        Function.shared.timeUpdate()
        city.text = appDelegate.currentCity.name
        tableView.reloadData()
    }
}

extension NowCity: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if indexPath.row == 0 {
            let cell1 = tableView.dequeueReusableCell(withIdentifier: "CurrentWeaher", for: indexPath) as! WeatherCell
            let city = appDelegate.currentCity
            if city != nil {
                print("current City \(city?.name)")
                print("current Weather \(appDelegate.currentWeather)")
                let weather = appDelegate.currentWeather
                // one in 3 hour
                cell1.time.text = weather?.date
                cell1.weatherName.text = weather?.weatherName ?? "" + " \(String(describing: weather?.weatherDescrib))"
                let temp = (weather?.temp ?? 0) - 273.15
                cell1.temp.text = String(Int(temp)) + "°c"
                cell1.pressure.text = "Pressure: " + String(weather?.pressure ?? 0) + " hpa"
                cell1.humidity.text = "Humidity: " + String(weather?.humidity ?? 0) + "%"
                cell1.windSpeed.text = "Wind Speed: " + String(weather?.windSpeed ?? 0) + " m/s"
                cell1.imgView.image = Function.shared.getWeatherIcon(name: weather?.icon ?? "01d")
            }
            cell = cell1
            
        } else {
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "CurrentWeaher2", for: indexPath)
            cell2.textLabel?.textColor = UIColor.white
//            cell2.textLabel?.text = "test cell text"
            cell = cell2
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            performSegue(withIdentifier: "showDetailsCurrent", sender: nil)
        }
    }
}
