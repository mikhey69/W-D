//
//  AddedCitiesListCell.swift
//  W&D
//
//  Created by mikhey on 12/28/18.
//  Copyright © 2018 mikhey. All rights reserved.
//

import UIKit

class AddedCitiesListCell: UITableViewCell {

    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var SelectedCity: UIView!
    
    var id: Int64 = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
