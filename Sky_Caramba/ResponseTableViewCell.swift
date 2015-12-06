//
//  ResponseTableViewCell.swift
//  Sky_Caramba
//
//  Created by Bartlomiej Siemieniuk on 06/12/2015.
//  Copyright © 2015 BSiemieniuk. All rights reserved.
//

import UIKit

class ResponseTableViewCell: UITableViewCell, ConCell {
    
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
        self.textLabel?.textColor   = UIColor.whiteColor()
        self.textLabel!.textAlignment = .Right        
    }


}
