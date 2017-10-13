//
//  NetworkUtilities.swift
//  GoTrainPOC
//
//  Created by Bahram Haddadi on 2017-10-12.
//  Copyright © 2017 Bahram Haddadi. All rights reserved.
//

import UIKit
import CoreLocation

class NetworkUtilities: NSObject {
    class func postImageToServer(image: UIImage, location: CLLocation , note: String, category: Category, completionHandler: @escaping () -> Void) {
        delay(delay: 1.0) {
            completionHandler()
        }
    }
    
}
