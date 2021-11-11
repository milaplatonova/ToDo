//
//  TableViewCell.swift
//  ToDo
//
//  Created by Lyudmila Platonova on 10.11.21.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
}


extension TableViewCell {
    
    func adjustCell(imageSystemName: String, tintColor: UIColor, text: NSMutableAttributedString) {
        self.cellImage.image = UIImage(systemName: imageSystemName)
        self.cellImage.tintColor = tintColor
        self.label.attributedText = text
    }
    
    
}
