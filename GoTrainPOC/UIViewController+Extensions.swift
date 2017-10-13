//
//  UIViewController+Extensions.swift
//  HCMA
//
//  Created by Clint Thorsten on 2017-03-10.
//  Copyright © 2017 IBM Canada. All rights reserved.
//

import UIKit

extension UIAlertController {
    func addActions(actions: UIAlertAction..., andPresentTo presenter: UIViewController? = nil) {
        for action in actions {
            self.addAction(action)
        }
        presenter?.present(self, animated: true) {}
    }
}

extension UIViewController {
    
    /**
     Show a "not implemented" message for functions that might now yet be implemented (with OK button)
     - parameter complete: closure that executes when user clicks OK button
    */
    func showNotImplemented(complete:(() -> Void)? = nil) {
        let message = NSLocalizedString("Sorry, this functionality has not been implemented", comment: "")
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.default) { (_) in
            if let complete = complete {
                complete()
            }
        }
        alertController.addActions(actions: okAction, andPresentTo:self)
        alertController.view.tintColor = UIColor.blue
    }
    
    /**
     Present an informational message (with an OK button)
     - parameter title: title of the info message
     - parameter message: detailed message
     - parameter complete: closure to execute when the OK button is pressed
    */
    func showInfoMessage(title: String?, message: String, complete:(() -> Void)? = nil) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.default) {(_) in
            complete?()
        }
        alertController.addActions(actions: okAction, andPresentTo:self)
        alertController.view.tintColor = UIColor.blue
    }
    
    /**
     Present an confirmation message (with a Cancel and OK button)
     - parameter title: title of the info message
     - parameter message: detailed message
     - parameter cancelButtonText: (optional) cancel button text - default is "Cancel"
     - parameter okButtonText: (optional) ok button text - default is "OK"
     - parameter cancelCompletion: closure to execute when the Cancel button is pressed
     - parameter okCompletion: closure to execute when the OK button is pressed
     */
    func showConfirmationMessage(title: String?, message: String, cancelButtonText: String? = NSLocalizedString("Cancel", comment: ""), cancelCompletion: (() -> Void)? = nil, okButtonText: String = NSLocalizedString("OK", comment: ""), okActionStyle: UIAlertActionStyle = .default, okCompletion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: okButtonText, style: okActionStyle) {(_) in
            if let complete = okCompletion {
                complete()
            }
        }
        let cancelAction = UIAlertAction(title: cancelButtonText, style: UIAlertActionStyle.cancel) {(_) in
            if let cancel = cancelCompletion {
                cancel()
            }
        }
        alertController.addActions(actions: cancelAction, okAction, andPresentTo:self)
        alertController.view.tintColor = UIColor.blue
    }
    
    /**
     Show alert to connect to the internet
     */
    func showNeedsInternet() {
        showInfoMessage(title: NSLocalizedString("This feature requires you to be online", comment: ""), message: NSLocalizedString("Please re-establish a connection to the internet to continue to use this function", comment: ""))
    }
    
    /**
     Show alert for authentication issue
    */
    func showAuthenticationError(_ notification: Notification, forceLogout: Bool? = false, isPasswordCheck: Bool? = false, completion: (() -> Void)? = nil) {
        if let errorCode = notification.userInfo?["errorCode"] as? Int {

            let lockoutCompletion = {
                // cancel change email challenge if it is in progress
                NotificationCenter.default.post(name: Notification.Name(rawValue: AppConstants.changeEmailChallengeCancel), object: self, userInfo: nil)
                NotificationCenter.default.post(name: Notification.Name(rawValue: AppConstants.userLogout), object: self, userInfo: nil)
            }

            switch errorCode {
            case 0, 100:
                if isPasswordCheck! {
                    showInfoMessage(title: NSLocalizedString("Incorrect Credentials", comment: ""), message: NSLocalizedString("The password provided is not correct.  Please try again.", comment: ""), complete: completion)
                } else {
                    showInfoMessage(title: NSLocalizedString("Incorrect Credentials", comment: ""), message: NSLocalizedString("The email and password combination provided is not correct.  If you have not already created an account, please tap the 'Sign Up Today' button.", comment: ""), complete: completion)
                }
            case 200:
                var blockedUntilStr = ""
                if let blockedUntil = notification.userInfo?["blockedUntil"] {
                    blockedUntilStr = String(describing: blockedUntil)
                }
                showInfoMessage(title:NSLocalizedString("Account Locked", comment: ""), message:"\(NSLocalizedString("Account has been locked due to too many unsuccessful sign-in attempts. You can try to sign in with this account again at: \n", comment: "")) \(blockedUntilStr)", complete: forceLogout! ? lockoutCompletion : completion)
            case 201:
                showInfoMessage(title:NSLocalizedString("Device Locked", comment: ""), message:"\(NSLocalizedString("Device has been locked due to too many unsuccessful sign-in attempts. You can try again with this device once the one hour lockout period has passed.", comment: ""))", complete: forceLogout! ? lockoutCompletion : completion)
            default:
                showInfoMessage(title: NSLocalizedString("Server Error", comment: ""), message: NSLocalizedString("There was a server error, please try again later.", comment: ""), complete: completion)
            }
        } else {
            showInfoMessage(title: NSLocalizedString("Server Error", comment: ""), message: NSLocalizedString("There was a server error, please try again later.", comment: ""), complete: completion)
        }
    }
    
    /// show an error message if camera is not found
    func showCameraNotFound(completion: (() -> Void)?) {
        showInfoMessage(title: NSLocalizedString("Camera Not Found", comment: ""), message: NSLocalizedString("You will be redirected to enter card details manually.  ", comment: "")) {
            if let completion = completion {
                completion()
            }
        }
    }
    
    /// show an error message if camera is not authorized
    func showCameraUnauthorizedError(completion: (() -> Void)?) {
        showInfoMessage(title: NSLocalizedString("Camera not authorized", comment: ""), message: NSLocalizedString("You will be redirected to enter card details manually.  If you would like to use the automated card scan capabilities of the app, please change your settings to allow access the camera.", comment: "")) {
            if let completion = completion {
                completion()
            }
        }
    }

    /**
     Check validity of passwords
     - parameter password: password to check
     */
    func isPasswordValid (password: String) -> Bool {
        
        // check for valid password length
        if password.characters.count < AppConstants.validPasswordLength {
            self.showInfoMessage(title: NSLocalizedString("Invalid password", comment: ""), message: NSLocalizedString("Minimum password length: \(AppConstants.validPasswordLength)", comment: ""))
            return false
        }
        
        /// check for uppercase
        let uppercaseSet = CharacterSet.uppercaseLetters
        if !(password.rangeOfCharacter(from: uppercaseSet, options: .regularExpression) != nil) {
            self.showInfoMessage(title: NSLocalizedString("Invalid password", comment: ""), message: NSLocalizedString("Must contain at least one uppercase letter.", comment: ""))
            return false
        }
        
        // check for non-alpha character (number or special character)
        let alphaSet = CharacterSet.letters
        if (password.rangeOfCharacter(from: alphaSet.inverted, options: .regularExpression) == nil) {
            self.showInfoMessage(title: NSLocalizedString("Invalid password", comment: ""), message: NSLocalizedString("Must contain at least one numeric or special character.", comment: ""))
            return false
        }
        
        return true
        
    }
    
    /**
     Open a call to customer service desk
    */
    func callHelpDesk() {
        
        // call customer service
        if let url = URL(string: "tel://\(AppConstants.customerSupportPhone)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        } else {
            showInfoMessage(title: NSLocalizedString("Could not start phone", comment: ""), message: NSLocalizedString("Theere was a problem starting the phone app.", comment: ""))
        }
        
    }
  
}
