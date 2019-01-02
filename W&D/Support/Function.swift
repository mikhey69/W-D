import Foundation
import UIKit
import SwiftyJSON

class Function: NSObject {
    
    static let shared = Function()
    private override init() {}
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func timeUpdate()  {
        let date = Date()
        let calendar = Calendar.current
        var day = String(calendar.component(.day, from: date))
        var month = String(calendar.component(.month, from: date))
        var hour = String(calendar.component(.hour, from: date))
        var minutes = String(calendar.component(.minute, from: date))
        let year = String(calendar.component(.year, from: date))
        print("hour2 \(hour)")
        if Int(month) ?? 0 < 10 {
            month = "0" + month
        }
        if Int(day) ?? 0 < 10 {
            day = "0" + day
        }
        if Int(hour) ?? 0 < 10 {
            hour = "0" + hour
        }
        if Int(hour) ?? 0 == 0 {
            hour = "00"
        }
        if Int(minutes) ?? 0 < 10 {
            minutes = "0" + minutes
        }
        appDelegate.currentTime = "\(year):\(month):\(day) \(hour):\(minutes)"
        weatherUpdate(year: year, month: month, day: day, hour: hour)
        
    }
    
    func weatherUpdate(year: String,month: String, day: String, hour: String) {
        //weather
        //check for bugs
        if appDelegate.currentCity != nil {
            //            var weather = appDelegate.currentCity.weather?[index]
            
            var a = hour
            var weatherHour = a
            
            switch Int(a)! {
            case 0..<3:
                print("hour \(hour) = 0")
                weatherHour = "00"
            case 3..<6:
                print("hour \(hour) = 3")
                weatherHour = "03"
            case 6..<9:
                print("hour \(hour) = 6")
                weatherHour = "06"
            case 9..<12:
                print("hour \(hour) = 9")
                weatherHour = "09"
            case 12..<15:
                print("hour \(hour) = 12")
                weatherHour = "12"
            case 15..<18:
                print("hour \(hour) = 15")
                weatherHour = "15"
            case 18..<21:
                print("hour \(hour) = 18")
                weatherHour = "18"
            case 21..<24:
                print("")
                weatherHour = "21"
            default:
                print("def \(hour)")
                weatherHour = "00"
            }
            
            var date: String?
            date = "\(year)-\(month)-\(day) \(String(weatherHour)):00:00"
            var currentWeather = appDelegate.currentCity.weather?.filter({$0.date == date})
            if currentWeather?.isEmpty ?? true {
                print("currentWeatherArray is empty")
                //need update data (alert)
            } else {
                let currentWeatherIndex = appDelegate.currentCity.weather?.firstIndex(of: currentWeather?.first! ?? (currentWeather?[0])!)
                print("currentWeatherIndex \(currentWeatherIndex!)")
                
                let distance = appDelegate.currentCity?.weather?.distance(from: 0, to: currentWeatherIndex ?? 0)
                
                for _ in 0..<(distance ?? 0) {
                    appDelegate.currentCity.weather?.removeFirst()
                }
                
                print("curr \(appDelegate.currentCity.name)")
                appDelegate.currentWeather = appDelegate.currentCity.weather?[0]
            }
        }
    }
    
    func getWeatherIcon(name: String) -> UIImage {
        var imgName = "01d"
        switch name {
        case "01d", "01n":
            imgName = "01d"
        case "02d","02n":
            imgName = "02d"
        case "03d","03n":
            imgName = "03d"
        case "04d","04n":
            imgName = "04d"
        case "09d","09n":
            imgName = "09d"
        case "11d","11n":
            imgName = "11d"
        case "13d","13n":
            imgName = "13d"
        case "10d","10n":
            imgName = "10d"
        case "50d","50n":
            imgName = "50d"
        default:
            imgName = "01d"
        }
        
        return UIImage(named: imgName) ?? UIImage()
    }
    
    
    func searchInJson() {
        DispatchQueue.global(qos: .userInteractive).async {
            
            if let path = Bundle.main.path(forResource: "city.list", ofType: "json") {
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path))
                    let json = try JSON(data: data)
                    print("count \(json.arrayValue.count)")
                    print(json)
                    for element in json.arrayValue {
                        let b = CityInfo(country: element["country"].stringValue,
                                         lat: element["coord"]["lat"].doubleValue,
                                         lon: element["coord"]["lon"].doubleValue,
                                         id: element["id"].intValue,
                                         name: element["name"].stringValue)
                        
                        if self.appDelegate.citiesJSON.contains(where: {$0.id == element["id"].intValue}) == false {
                            self.appDelegate.citiesJSON.append(b)
                        }
                    }
                    print("counttt \(self.appDelegate.citiesJSON.count)")
                    if self.appDelegate.citiesJSON.count < 0 {
                        let encodedData: Data = try NSKeyedArchiver.archivedData(withRootObject: self.appDelegate.citiesJSON, requiringSecureCoding: false)
                        UserDefaults.standard.set(encodedData, forKey: "citiesJSON")
                        UserDefaults.standard.synchronize()
                        print("userDef is done")
                    }
                } catch {
                    print("json error")
                }
            }
        }
        
    }
    
}
