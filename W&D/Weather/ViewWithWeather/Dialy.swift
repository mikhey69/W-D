//
//  FavorCities.swift
//  weather
//
//  Created by mikhey on 12/24/18.
//  Copyright © 2018 mikhey. All rights reserved.



import UIKit
import GoogleMobileAds

class Dialy: UIViewController {
    
    
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var city: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var isSwitch: UISwitch!
    
    var dayWeather = [Weather]()
    var hourlyWeather = [Weather]()
    var weatherDate = ""
    var weatherHour = ""
    
    var weathercarsDictionary = [String: [Weather]]()
    var weatherSectionTitles = [String]()
    var weather = [Weather]()
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //load Ad
        bannerView.adUnitID = "ca-app-pub-6849226060302158/9737223213"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateWeather), name: NSNotification.Name("ChangeCity"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.showSideMenu), name: NSNotification.Name("showSideMenu"), object: nil)
        
        isSwitch.addTarget(self,
                           action: #selector(updateWeather),
                           for: UIControl.Event.valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateWeather()
    }
    
    func sections() {
        
        weather.removeAll()
        weatherSectionTitles.removeAll()
        weathercarsDictionary.removeAll()
        
        if isSwitch.isOn {
            weather = appDelegate.currentCity.weather ?? [Weather]()
        } else {
            weather = dayWeather
        }
        
        for info in weather {
            let weatherKey = String((info.date?.dropLast(9) ?? ""))
            if var weatherValues = weathercarsDictionary[weatherKey] {
                weatherValues.append(info)
                weathercarsDictionary[weatherKey] = weatherValues
            } else {
                weathercarsDictionary[weatherKey] = [info]
            }
        }
        
        weatherSectionTitles = [String](weathercarsDictionary.keys)
        weatherSectionTitles = weatherSectionTitles.sorted(by: { $0 < $1 })
    }
    
    @objc func showSideMenu() {
        performSegue(withIdentifier: "showSideMenu2", sender: nil)
    }
    
    @objc func updateWeather() {
         Function.shared.timeUpdate()
        if appDelegate.currentCity != nil {
            city.text = appDelegate.currentCity.name
            
            if appDelegate.currentCity != nil {
                guard appDelegate.currentWeather != nil else {
                    tableView.reloadData()
                    return
                }
                
                weatherDate = String(appDelegate.currentWeather?.date?.dropLast(9) ?? "")
                weatherHour = String(appDelegate.currentWeather?.date?.dropFirst(11).dropLast(6) ?? "")
                dayWeather.removeAll()
                for i in  appDelegate.currentCity?.weather ?? [Weather]() {
                    let day = String(i.date?.dropFirst(11).dropLast(6) ?? "")
                    if day == weatherHour {
                        if dayWeather.contains(where: {$0.date == i.date}) == false {
                            dayWeather.append(i)
                        }
                    }
                }
                sections()
                tableView.reloadData()
            }
            tableView.reloadData()
        }
    }
}

//extension Dail
extension Dialy: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let weatherValue = weatherSectionTitles[section]
        if let carValues = weathercarsDictionary[weatherValue] {
            return carValues.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DailyHourly", for: indexPath) as! DialyWeatherCell
        let weatherKey = weatherSectionTitles[indexPath.section]
        
            if let weatherValues = weathercarsDictionary[weatherKey] {
                cell.weatherInfo = weatherValues[indexPath.row]
                cell.temp.text = String(Int((cell.weatherInfo.temp ?? 0) - 273.15)) + "°"
                //add feel temp
                cell.tempFeel.text = "/" + String(Int((cell.weatherInfo.temp ?? 0) - 273.15)) + "°"
                cell.time.text = String(cell.weatherInfo.date?.dropFirst(11).dropLast(3) ?? "")
                cell.imgView.image = Function.shared.getWeatherIcon(name: cell.weatherInfo.icon ?? "")
            }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return weatherSectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title = ""
        if isSwitch.isOn {
           title = weatherSectionTitles[section]
        } else {
           title = weatherSectionTitles[section]
        }
        return title
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! DialyWeatherCell
        performSegue(withIdentifier: "showDetailsDailyHourly", sender: cell)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailsDailyHourly" {
            let vc = segue.destination as! DetailsWeather
            let weather = sender as! DialyWeatherCell
            vc.weather = weather.weatherInfo
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
//        let footerViewSub = UIView()
            footerView.backgroundColor = UIColor.black
        return footerView
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerLabel = UILabel()
        let headerView = UIView()
            headerView.backgroundColor = UIColor.black
            headerLabel =
                UILabel(frame: CGRect(x: 5, y: 0, width:
                    tableView.bounds.size.width, height: tableView.bounds.size.height))
        
            headerLabel.font = UIFont.boldSystemFont(ofSize: 15)
            headerLabel.textColor = UIColor(red: 255/255, green: 133/255, blue: 255/255, alpha: 1)
            headerLabel.text = self.tableView(self.tableView, titleForHeaderInSection: section)
            headerLabel.sizeToFit()
            headerView.addSubview(headerLabel)
        
        return headerView
    }
    
    
}
