//
//  CitySearch.swift
//  W&D
//
//  Created by mikhey on 12/28/18.
//  Copyright © 2018 mikhey. All rights reserved.
//

import UIKit
import SwiftyJSON

class CitySearch: UIViewController, UISearchBarDelegate {

    
    @IBOutlet weak var searchBar: UISearchBar!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.closeSearch), name: NSNotification.Name("CloseSearch"), object: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc func closeSearch() {
        self.removeFromParent()
        self.view.removeFromSuperview()
        NotificationCenter.default.post(name: NSNotification.Name("ChangeCity"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name("showSideMenu"), object: nil)
        
    }
    
    
    @IBAction func addSity(_ sender: Any) {
        if searchBar.text != "" && searchBar.text != " " {
            GetWeather.shared.getWeather(forCity: searchBar.text ?? " ", showAlert: true)
        }
    }
    
    
    @IBAction func cancelView(_ sender: Any) {
        self.removeFromParent()
        self.view.removeFromSuperview()
    }
}

extension CitySearch {
    //search bar
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("search text is \(searchText)")
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.endEditing(true)
        searchBar.resignFirstResponder()
        return true
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
        searchBar.endEditing(true)
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
