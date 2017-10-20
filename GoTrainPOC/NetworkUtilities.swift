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
    class func postImageToServer(image: UIImage, location: CLLocation , note: String, category: Category, completionHandler: @escaping (_ error: Error?) -> Void) {
        let url = "https://gotrainissuetrackertest.mybluemix.net/submit?long=\(location.coordinate.longitude)&lat=\(location.coordinate.latitude)&description=\(category.name)&note=\(note)&debug=true".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        let request = NSMutableURLRequest(url: URL(string: url!)!)
        request.httpMethod = "POST"
        
        let boundary = NSUUID().uuidString
        let fullData = photoDataToFormData(data: UIImageJPEGRepresentation(image, 1) as! NSData, boundary:boundary, fileName:"fileName.jpg")
        
        request.setValue("multipart/form-data; boundary=" + boundary, forHTTPHeaderField: "Content-Type")
        request.setValue(String(fullData.length), forHTTPHeaderField: "Content-Length")
        request.httpBody = fullData as Data
        request.httpShouldHandleCookies = false
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
//            print("response = \(response)")
            completionHandler(error)
        }
        task.resume()
    }
    
    class func sentimentalAnalysis(text: String, completionHandler: @escaping (_ error: Error?, _ score: Float, _ toneName: String) -> Void) {
        var score: Float = 0.0
        var toneName: String = ""
        let currentDate = Date()
        let dataFormatter = DateFormatter()
        dataFormatter.dateFormat = "yyyy-MM-dd"
        let currentDateString = dataFormatter.string(from: currentDate)
        let url = "https://watson-api-explorer.mybluemix.net/tone-analyzer/api/v3/tone?text=\(text)&version=\(currentDateString)&sentences=true".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        let request = NSMutableURLRequest(url: URL(string: url!)!)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if let dat = data {
                let json = try? JSONSerialization.jsonObject(with: dat, options: [])
                if let dictionary = json as? [String: Any] {
                    if let document_tone = dictionary["document_tone"] as? [String: Any] {
                        if let tones = document_tone["tones"] as? [[String : Any]] {
                            if let firstResult = tones.first {
                                score = firstResult["score"] as? Float ?? 0.0
                                toneName = firstResult["tone_name"] as? String ?? ""
                            }
                        }
                    }
                }
            }
            completionHandler(error, score, toneName)
        }
        task.resume()
    }
    
    
    class func photoDataToFormData(data:NSData,boundary:String,fileName:String) -> NSData {
        let fullData = NSMutableData()
        
        // 1 - Boundary should start with --
        let lineOne = "--" + boundary + "\r\n"
        fullData.append(lineOne.data(using: String.Encoding.utf8,allowLossyConversion: false)!)
        
        // 2
        let lineTwo = "Content-Disposition: form-data; name=\"file\"; filename=\"" + fileName + "\"\r\n"
        NSLog(lineTwo)
        fullData.append(lineTwo.data(using: String.Encoding.utf8, allowLossyConversion: false)!)
        
        // 3
        let lineThree = "Content-Type: image/jpg\r\n\r\n"
        fullData.append(lineThree.data(using: String.Encoding.utf8, allowLossyConversion: false)!)
        
        // 4
        fullData.append(data as Data)
        
        // 5
        let lineFive = "\r\n"
        fullData.append(lineFive.data(using: String.Encoding.utf8, allowLossyConversion: false)!)
        
        // 6 - The end. Notice -- at the start and at the end
        let lineSix = "--" + boundary + "--\r\n"
        fullData.append(lineSix.data(using: String.Encoding.utf8, allowLossyConversion: false)!)
        
        return fullData
    }
    
    
}
