//
//  userCar.swift
//  FindMyCar
//
//  Created by Nick Perkins on 5/15/16.
//  Copyright © 2016 Nick Perkins. All rights reserved.
//

import UIKit

class userCar: NSObject, NSCoding {
    
    var title : String?
    var subtitle : String?
    var coordinate : String?
    
    init(title : String, subtitle: String, coordinate: String) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let title = aDecoder.decodeObjectForKey("title") as? String,
            let subtitle = aDecoder.decodeObjectForKey("subtitle") as? String,
            let coordinate = aDecoder.decodeObjectForKey("coordinate") as? String
            else{return nil}
        
        self.init(title:title, subtitle: subtitle, coordinate: coordinate)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(title, forKey: "title")
        aCoder.encodeObject(subtitle, forKey: "subtitle")
        aCoder.encodeObject(coordinate, forKey: "coordinate")
    }

    

}
