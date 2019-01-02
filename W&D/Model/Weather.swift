import Foundation

public class Weather: NSObject, NSCoding {
    
    var weatherName: String?
    var weatherDescrib: String?
    var pressure: Double?
    var temp: Double?
    var humidity: Double?
    var date: String?
    var windSpeed: Double?
    var icon: String?
    
    
    //decoding
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(weatherName, forKey: "weatherName")
        aCoder.encode(weatherDescrib, forKey: "weatherDescrib")
        aCoder.encode(pressure, forKey: "pressure")
        aCoder.encode(temp, forKey: "temp")
        aCoder.encode(humidity, forKey: "humidity")
        aCoder.encode(date, forKey: "date")
        aCoder.encode(windSpeed, forKey: "windSpeed")
        aCoder.encode(icon, forKey: "icon")
    }
    
    init(weatherName: String, weatherDescrib: String, pressure: Double, temp: Double, humidity: Double, date: String, windSpeed: Double, icon: String) {
        self.weatherName = weatherName
        self.weatherDescrib = weatherDescrib
        self.pressure = pressure
        self.temp = temp
        self.humidity = humidity
        self.date = date
        self.windSpeed = windSpeed
        self.icon = icon
    }
    
    public required convenience init?(coder aDecoder: NSCoder) {
        let weatherName = aDecoder.decodeObject(forKey: "weatherName") as! String
        let weatherDescrib = aDecoder.decodeObject(forKey: "weatherDescrib") as! String
        let pressure = aDecoder.decodeObject(forKey: "pressure") as! Double
        let temp = aDecoder.decodeObject(forKey: "temp") as! Double
        let humidity = aDecoder.decodeObject(forKey: "humidity") as! Double
        let date = aDecoder.decodeObject(forKey: "date") as! String
        let windSpeed = aDecoder.decodeObject(forKey: "windSpeed") as! Double
        let icon = aDecoder.decodeObject(forKey: "icon") as? String
        self.init(weatherName: weatherName,
                  weatherDescrib: weatherDescrib,
                  pressure: pressure,
                  temp: temp,
                  humidity: humidity,
                  date: date,
                  windSpeed: windSpeed,
                  icon: icon ?? "default")
    }
}
