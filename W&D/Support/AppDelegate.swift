//
//  AppDelegate.swift
//  W&D
//
//  Created by mikhey on 12/25/18.
//  Copyright © 2018 mikhey. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import GoogleMobileAds
import Crashlytics
import Fabric
import SwiftyJSON

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var allCities = [City]()
    var currentCity: City!
    var currentWeather: Weather!
    var currentTime: String = ""
    var pageControlHight: CGRect!
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //Firebase
        FirebaseApp.configure()
        //adMob
        GADMobileAds.configure(withApplicationID: "ca-app-pub-6849226060302158~6564264962")
        //added cities
        GetWeather.shared.fetchCoreData()
        
        Fabric.sharedSDK().debug = true
        
        DispatchQueue.global(qos: .userInteractive).async {
            self.addCitiesList()
        }
        
        if !allCities.isEmpty {
            
            if currentCity == nil || currentCity.name == nil {
                if UserDefaults.standard.integer(forKey: "CurrentCityId") != 0 {
                    currentCity = allCities.filter({$0.id == UserDefaults.standard.integer(forKey: "CurrentCityId")}).first
                } else {
                    currentCity = allCities[0]
                    UserDefaults.standard.set(currentCity.id, forKey: "CurrentCityId")
                }
            }
        } else {
            //need add city
        }
        
//        allCities.removeAll()
//        removeDataFrom(entity: "City")
        
        return true
    }
    
    func addCitiesList() {
        if let path = Bundle.main.path(forResource: "city.list", ofType: "json") {
            
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                let json = try JSON(data: data)
                print("count \(json.arrayValue.count)")
                var a = json.arrayValue.filter { (item) -> Bool in
                    if item["name"].string == "Kiev" {
                        print("done Kiev")
                        return true
                    }
                    return false
                }
                print("ap \(a.first)")
//                print("json \(json)")
                for i in json.arrayValue {
//                    let elemenet =
                }
                
            } catch {
                print("json error")
            }
        }
    }

    func removeDataFrom(entity: String) {
        // create the delete request for the specified entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        // get reference to the persistent container
        let persistentContainer = CoreDataManager.shared.persistentContainer
        
        // perform the delete
        do {
            try persistentContainer.viewContext.execute(deleteRequest)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        CoreDataManager.shared.saveContext()
    }
}

