//
//  ConCellTableViewCell.swift
//  Sky_Caramba
//
//  Created by Bartlomiej Siemieniuk on 06/12/2015.
//  Copyright © 2015 BSiemieniuk. All rights reserved.
//

import UIKit


enum CellType {
    
    case MyText
    case Response
    case Movie
    
}

protocol ConCell {
    var type:CellType? { get set }
    func customizeCell(data: Data);
    
}

class ConCellTableViewCell: UITableViewCell, ConCell {
    
    var type: CellType?;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func customizeCell(data:Data) {
        self.type                   = data.type!;
        self.textLabel!.text        = data.text
        
        self.textLabel?.textColor   = UIColor(
            red: 135/255.0,
            green: 160.0/255.0,
            blue: 175.0/255.0,
            alpha: 1.0
        )
        
    }

}

