import Foundation

class CityInfo: NSObject, NSCoding {
    var country: String?
    var lat: Double?
    var lon: Double?
    var id: Int?
    var name: String?
    
    //decoding
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(country, forKey: "country")
        aCoder.encode(lat, forKey: "lat")
        aCoder.encode(lon, forKey: "lon")
        aCoder.encode(id, forKey: "id")
        aCoder.encode(name, forKey: "name")
        
    }
    
    init(country: String, lat: Double, lon: Double, id: Int, name: String) {
        self.country = country
        self.lat = lat
        self.lon = lon
        self.id = id
        self.name = name
    }
    
    public required convenience init?(coder aDecoder: NSCoder) {
        let country = aDecoder.decodeObject(forKey: "country") as! String
        let lat = aDecoder.decodeObject(forKey: "lat") as! Double
        let lon = aDecoder.decodeObject(forKey: "lon") as! Double
        let id = aDecoder.decodeObject(forKey: "id") as! Int
        let name = aDecoder.decodeObject(forKey: "name") as! String
    
        self.init(country: country,
                  lat: lat,
                  lon: lon,
                  id: id,
                  name: name)
    }
}
