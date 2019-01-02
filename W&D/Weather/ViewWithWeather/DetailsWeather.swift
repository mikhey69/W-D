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

class DetailsWeather: UIViewController {
    
    var city: City!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
