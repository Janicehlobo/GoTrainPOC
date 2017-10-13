//
//  Categories.swift
//  GoTrainPOC
//
//  Created by Bahram Haddadi on 2017-10-12.
//  Copyright © 2017 Bahram Haddadi. All rights reserved.
//

import UIKit

class Categories: NSObject {
    var categories: [Category] = []
    
    override init() {
        super.init()
        
        if let path = Bundle.main.path(forResource: "Categories", ofType: "json") {
            do {
                let jsonData = try NSData(contentsOfFile: path, options: NSData.ReadingOptions.mappedIfSafe)
                let jsonResult: NSDictionary = try JSONSerialization.jsonObject(with: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                let cats = jsonResult.value(forKey: "Categories") as! NSArray
                for cat in cats {
                    if let c = cat as? Dictionary<String, Any> {
                        self.categories.append(Category(name: c["Name"] as? String ?? "", words: c["Words"] as? Array<String> ?? []))
                    }
                }
            } catch {}
        } else {
            print("Invalid filename/path.")
        }
    }
    
    func findCategory(value: String) -> Category? {
        return self.categories.first {$0.words.contains(value)}
    }
}
