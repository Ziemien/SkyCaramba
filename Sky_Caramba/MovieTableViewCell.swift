//
//  MovieTableViewCell.swift
//  Sky_Caramba
//
//  Created by Bartlomiej Siemieniuk on 06/12/2015.
//  Copyright © 2015 BSiemieniuk. All rights reserved.
//

import UIKit

class MovieTableViewCell:  UITableViewCell, ConCell {
    
    var type: CellType?;
    
    @IBOutlet weak var picture: UIImageView!
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var genre: UILabel!
    
    @IBOutlet weak var director: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func customizeCell(data:Data) {
        self.type  = data.type!;
        
        self.title.text = data.title!
        self.genre.text = data.genre!
        self.director.text = ""
        
        if let url = data.pictureUrl {
            let nsURL = NSURL(string: url)
            
            if let picData  = NSData(contentsOfURL: nsURL!) {
                self.picture.image = UIImage(data: picData)
                self.picture.contentMode   = .ScaleAspectFill;
                self.picture.clipsToBounds = true
            }
            
            

        }
        
        self.backgroundColor =
            UIColor(red: 135/255.0, green: 160.0/255.0, blue: 175.0/255.0, alpha: 0.05)

    }
    
    
}
