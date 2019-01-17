//
//  FactTableViewCell.swift
//  ChuckN
//
//  Created by Konstantin Tsistjakov on 17/01/2019.
//  Copyright © 2019 Chipp Studio. All rights reserved.
//

import UIKit

class FactTableViewCell: UITableViewCell {

    // MARK: - UI
    @IBOutlet weak var favoriteMark: UIImageView!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    // MARK: - Override
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
