//
//  Book.swift
//  Prototype
//
//  Created by Victor Hugo Carvalho Barros on 2017-11-14.
//  Copyright © 2017 Kinvey. All rights reserved.
//

import Kinvey

class Book: Entity {
    
    @objc dynamic var title: String?
    
    override class func collectionName() -> String {
        return "Book"
    }
    
    override func propertyMapping(_ map: Map) {
        super.propertyMapping(map)
        
        title <- ("title", map["title"])
    }
    
}

class Book50k: Entity {
    
    @objc dynamic var title: String?
    
    override class func collectionName() -> String {
        return "50k-Books"
    }
    
    override func propertyMapping(_ map: Map) {
        super.propertyMapping(map)
        
        title <- ("title", map["title"])
    }
    
}
