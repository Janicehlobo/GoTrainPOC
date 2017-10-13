//
//  Category.swift
//  GoTrainPOC
//
//  Created by Bahram Haddadi on 2017-10-12.
//  Copyright © 2017 Bahram Haddadi. All rights reserved.
//

import UIKit

class Category: NSObject {
    var name: String = ""
    var words: [String] = []
    
    init(name: String, words: [String]) {
        super.init()
        
        self.name = name
        self.words = words
    }
}
