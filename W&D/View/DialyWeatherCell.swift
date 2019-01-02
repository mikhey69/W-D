//
//  DialyWeatherCell.swift
//  W&D
//
//  Created by mikhey on 1/2/19.
//  Copyright © 2019 mikhey. All rights reserved.
//

import Foundation
import UIKit

class DialyWeatherCell: UITableViewCell {
    
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var weather: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var tempFeel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
