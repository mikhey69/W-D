//
//  DetailsCell.swift
//  W&D
//
//  Created by mikhey on 1/4/19.
//  Copyright © 2019 mikhey. All rights reserved.
//

import UIKit

class DetailsCell: UITableViewCell {
    
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var valueLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
