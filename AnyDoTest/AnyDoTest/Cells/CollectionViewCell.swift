//
//  CollectionViewCell.swift
//  AnyDoTest
//
//  Created by anydo on 29/04/2018.
//  Copyright © 2018 anydo. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var bgColor: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var weightLabel: UILabel!
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
