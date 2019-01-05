import Foundation
import Alamofire
import SwiftyJSON
import CoreData

class GetWeather: NSObject {
    
    static let shared = GetWeather()
    private override init() {}
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let openweatherMapBaseURL = "http:/api.openweathermap.org/data/2.5/forecast"
    let openweatherMaAPIKey = "02e192611291898113072edd948bbe34"
    
    func getWeather(forCity: String, showAlert: Bool) {
        let myUrl = "\(openweatherMapBaseURL)?&q=\(forCity)&APPID=\(openweatherMaAPIKey)"
        print("myUrl \(myUrl)")
        
        Alamofire.request(myUrl).responseJSON { (response) in
            guard response.result.value != nil else {
                print("weather request is failed")
                return }
            let json = JSON(response.result.value!)
            let weatherJson = json["list"].arrayValue
            var weather = [Weather]()
            let id = json["city"]["id"].int64Value
            for element in weatherJson {
                let weatherPoint = Weather(weatherName: element["weather"].arrayValue.first?["main"].stringValue ?? "none",
                                         weatherDescrib: element["weather"].arrayValue.first?["description"].stringValue ?? "none",
                                         pressure: element["main"]["pressure"].doubleValue,
                                         temp: element["main"]["temp"].doubleValue,
                                         humidity: element["main"]["humidity"].doubleValue,
                                         date: element["dt_txt"].stringValue,
                                         windSpeed: element["wind"]["speed"].doubleValue,
                                         icon: element["weather"].arrayValue.first?["icon"].stringValue ?? "none")
               weather.append(weatherPoint)
            }
            
            if self.appDelegate.allCities.contains(where: {$0.id == id}) == false {
                print("add")
                self.saveCity(id: id,
                              coordLat: json["city"]["coord"]["lat"].doubleValue,
                              coordLon: json["city"]["coord"]["lon"].doubleValue,
                              name: json["city"]["name"].stringValue,
                              country: json["city"]["country"].stringValue,
                              weather: weather, showAlert: showAlert)
            } else {
                print("change")
                self.deleteFromCoreData(id: id)
                self.saveCity(id: id,
                              coordLat: json["city"]["coord"]["lat"].doubleValue,
                              coordLon: json["city"]["coord"]["lon"].doubleValue,
                              name: json["city"]["name"].stringValue,
                              country: json["city"]["country"].stringValue,
                              weather: weather, showAlert: showAlert)
            }
        }
    }
    
    func saveCity(id: Int64, coordLat: Double, coordLon: Double, name: String, country: String, weather: [Weather], showAlert: Bool) {
        print("saved element")
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "City", in: context)
        let categObject = NSManagedObject(entity: entity!, insertInto: context) as! City
        categObject.id = id
        categObject.coordLat = coordLat
        categObject.coordLon = coordLon
        categObject.name = name
        categObject.weather = weather
        categObject.country = country
//        self.appDelegate.allCities.append(categObject)
        //check core data if contains sity with id, need replace city/ else save city
        
        
        
        //save context
        if context.hasChanges {
            print("context is change")
            do {
                try context.save()
                print("saved context")
            } catch {
                print("Error111")
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
        
        self.fetchCoreData()
        
        appDelegate.currentCity = appDelegate.allCities.filter({$0.id == id}).first
        appDelegate.currentWeather = appDelegate.currentCity.weather?[0]
        if showAlert {
            UserDefaults.standard.set(appDelegate.currentCity.id, forKey: "CurrentCityId")
            NotificationCenter.default.post(name: NSNotification.Name("CloseSearch"), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name("showSideMenu"), object: nil)
        }
       
    }

    func fetchCoreData() {
        print("fetch core data")
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let fetchReq: NSFetchRequest<City> = City.fetchRequest()
        
        do {
            appDelegate.allCities = try context.fetch(fetchReq)
            print("allCity: \(appDelegate.allCities.count)")
            //current City
            
            if !appDelegate.allCities.isEmpty {
                
                if appDelegate.currentCity == nil || appDelegate.currentCity.name == nil {
                    if UserDefaults.standard.integer(forKey: "CurrentCityId") != 0 {
                        appDelegate.currentCity = appDelegate.allCities.filter({$0.id == UserDefaults.standard.integer(forKey: "CurrentCityId")}).first
                        print("sss \(appDelegate.allCities.filter({$0.id == UserDefaults.standard.integer(forKey: "CurrentCityId")}).count)")
                        if appDelegate.currentCity == nil {
                            appDelegate.currentCity = appDelegate.allCities[0]
                        }
                        print("1")
                    } else {
                        print("2")
                        appDelegate.currentCity = appDelegate.allCities[0]
                    }
                    print("app \(String(describing: appDelegate.currentCity))")
                    appDelegate.currentWeather = appDelegate.currentCity.weather?[0]
                }
            } else {
                //need add city
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteFromCoreData(id: Int64) {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<City> = City.fetchRequest()
        fetchRequest.predicate = NSPredicate.init(format: "id==\(id)")
        let objects = try! context.fetch(fetchRequest)
        for obj in objects {
            if appDelegate.allCities.contains(where: {$0.id == obj.id}) {
                print("name deleted from Core Data  \(String(describing: obj.name))")
                context.delete(obj)
            } else {
                print("dont have City with this id \(id)")
            }
        }
        
        do {
            try context.save()
            print("seve delete context")
        } catch {
            print("context error")
        }
    }
}
