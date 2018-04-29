//
//  GroceryItem.swift
//  AnyDoTest
//
//  Created by anydo on 29/04/2018.
//  Copyright © 2018 anydo. All rights reserved.
//

import UIKit
import SwiftyJSON

class GroceryItem: NSObject {
    
    var bgColor:String?
    var name:String?
    var weight:String?

    init?(itemJson:JSON) {
        self.bgColor = itemJson["bagColor"].stringValue
        self.name = itemJson["name"].stringValue
        self.weight = itemJson["weight"].stringValue
    }

}
