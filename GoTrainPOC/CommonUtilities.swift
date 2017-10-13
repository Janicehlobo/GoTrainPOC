//
//  CommonUtilities.swift
//  HCMA
//
//  Created by Clint Thorsten on 2017-03-09.
//  Copyright © 2017 IBM Canada. All rights reserved.
//

import Foundation

/**
 Helper function to add code to the main queue
 - parameter block: code to run in the main queue
 */
public func runOnMain(block: @escaping () -> Void) {
    // Only dispatch async if we are NOT on the main thread already.
    if Thread.current.isMainThread {
        block()
    } else {
        DispatchQueue.main.async(execute: block)
    }
}

/**
 Helper function to add code to the main queue with a delay
 - paramater delay: amout of time to wait
 - parameter closure: code to run in the main queue
 */
public func delay(delay: Double, closure: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
        closure()
    }
}

/**
 Helper function to synchronize threads
 - paramater lock: object to lock
 - parameter closure: code to execute when unlocked
 */
public func synchronized(lock: AnyObject, closure: () -> Void) {
    objc_sync_enter(lock)
    defer {
        objc_sync_exit(lock)
    }
    return closure()
}

/**
 Detect if app is in local mode
 **/
public func isLocalMode() -> Bool {
    return UserDefaults.standard.bool(forKey: "local_mode")
}

/**
 Log errors into the debug log
 - parameter message: brief description of error
 - parameter error: error object with specific error details
 */
public func logError(message: String, error: Error?) {
    if let nserror = error as NSError? {
        print("Error Code: \(nserror.code) Message: \(nserror.localizedDescription)")
    } else {
        print("Error Message: \(error?.localizedDescription ?? "N/A")")
    }
}
