//
//  BaseVC.swift
//  HuskyMapTest
//
//  Created by Bahram Haddadi on 2017-02-27.
//  Copyright © 2017 Bahram Haddadi. All rights reserved.
//

import UIKit

class BaseVC: UIViewController {
    public var keyboardHeight: CGFloat = 0
    public var spinnerBackground: UIView!
    public var spinner = UIActivityIndicatorView()
    private var toastLabel: UILabel!
    private var toastView: UIView!
    private var noConnectionAlertView: UIView!
    private var lblNoConnection: UILabel!
    private var viewOriginalTop: CGFloat = 0
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup spinner
        spinnerBackground = UIView(frame: self.view.frame)
        spinnerBackground.backgroundColor = UIColor.black
        spinnerBackground.alpha = 0.4
        
        spinner.frame = CGRect(x: self.view.frame.width/2 - spinner.frame.width/2, y: self.view.frame.height/2 - spinner.frame.height/2, width: spinner.frame.width, height: spinner.frame.height)
        
        spinner.isHidden = true
        spinnerBackground.isHidden = true
        view.addSubview(spinnerBackground)
        view.addSubview(spinner)
    
        spinnerBackground.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        spinnerBackground.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        spinnerBackground.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        spinnerBackground.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        spinnerBackground.translatesAutoresizingMaskIntoConstraints = false
        
        let centerXConstraint = NSLayoutConstraint(item: spinner, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.centerX, multiplier: 1.0, constant: 0)
        let centerYConstraint =  NSLayoutConstraint(item: spinner, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.centerY, multiplier: 1.0, constant: 60) //60 is navbar height
        
        NSLayoutConstraint.activate([centerXConstraint, centerYConstraint])
        spinner.translatesAutoresizingMaskIntoConstraints = false

        //setup toast view
        toastView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        toastView.layer.cornerRadius = 5
        toastView.layer.shadowColor = UIColor.black.cgColor
        toastView.layer.shadowOffset = CGSize(width: 0, height: 2)
        toastView.layer.shadowRadius = 9
        toastView.layer.shadowOpacity = 0.9
        toastView.layer.masksToBounds = false
        toastView.backgroundColor = UIColor.blue
        toastView.alpha = 0
        let lblMessage = UILabel()
        lblMessage.textColor = UIColor.white
        lblMessage.numberOfLines = 3
        lblMessage.textAlignment = .center
        toastView.addSubview(lblMessage)
        view.addSubview(toastView)
        
        //add no connection view to
        if let foundView = navigationController?.view.viewWithTag(32768) {
            noConnectionAlertView = foundView
        } else {
            noConnectionAlertView = UIView(frame: CGRect(x: 0, y: 64, width: view.frame.size.width, height: 0))
            noConnectionAlertView.backgroundColor = UIColor.red
            lblNoConnection = UILabel(frame: CGRect(x:0, y:0, width: noConnectionAlertView.frame.size.width, height: noConnectionAlertView.frame.size.height))
            lblNoConnection.textColor = UIColor.white
            lblNoConnection.textAlignment = .center
            lblNoConnection.text = NSLocalizedString("You Are Currently Offline", comment: "")
//            lblNoConnection.font = UIFont.huskyConfirmation()
            noConnectionAlertView.addSubview(lblNoConnection)
            noConnectionAlertView.tag = 32768
            navigationController?.view.addSubview(noConnectionAlertView)
        }
        
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        checkInternetConnection()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewOriginalTop = view.frame.origin.y
    }

    /// show or hide spinner in middle of screen
    ///
    /// - parameter show: show the spiiner if true, otherwise hide the spinner
    func showSpinner(show: Bool) {
        DispatchQueue.main.async {
            if show {
                self.spinner.startAnimating()
            } else {
                self.spinner.stopAnimating()
            }
            self.spinnerBackground.isHidden = !show
            self.spinner.isHidden = !show
        }
    }
    
    /// show toast on screen
    ///
    /// - parameter message: message to show
    /// - parameter style: style of toast
    func showToast(message: String, style: ToastStyleType) {
        DispatchQueue.main.async {
            self.view.bringSubview(toFront: self.toastView)
            let maxWidth = self.view.frame.size.width - 80
            let lblMessage = self.toastView.subviews[0] as? UILabel
            let attributes = [NSAttributedStringKey.font: lblMessage?.font]
            lblMessage?.text = message
            
            let messageStr = message as NSString
            let rect = messageStr.boundingRect(with: CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude),
                                               options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                               attributes: attributes,
                                               context: nil)
            
            self.toastView.frame = CGRect(x: (self.view.frame.size.width - rect.size.width - 40) / 2,
                                          y: (self.view.frame.size.height - rect.size.height) / 2,
                                          width: rect.size.width + 40 ,
                                          height: rect.size.height + 20)
            lblMessage?.frame = CGRect(x: 20, y: 10, width: rect.size.width, height: rect.size.height)
            lblMessage?.numberOfLines = 0
            lblMessage?.textAlignment = .center
            
            //set toast color based on styletype
            switch style {
                case .information:
                    self.toastView.backgroundColor = UIColor.gray
                case .warning:
                    self.toastView.backgroundColor = UIColor.blue
                case .error, .criticalError:
                    self.toastView.backgroundColor = UIColor.red
                default:
                    self.toastView.backgroundColor = UIColor.gray
            }
            
            UIView.animate(withDuration: AppConstants.toastAnimateTime, animations: {
                self.toastView.alpha = 1
            }, completion: { (_: Bool) in
                UIView.animateKeyframes(withDuration: AppConstants.toastAnimateTime, delay: AppConstants.toastStayOnScreenTime, options: [], animations: {
                    self.toastView.alpha = 0
                }, completion: { (_: Bool) in
                    //
                })
            })
        }
    }

    /// checks if we are connected to network and shows proper alert window if we are not connected
    ///
    /// - returns: true if connected and false if not
    func checkInternetConnection() -> Bool {
        let connected = isConnectedToNetwork()
        //noConnectionAlertView.isHidden = isConnectedToNetwork()
        self.view.bringSubview(toFront: noConnectionAlertView)
        if !connected {
            animateConnectionAlertView()
        }
        
        return connected
    }

    /// checks if we are connected to network
    ///
    /// - returns: true if connected and false if not
    func isConnectedToNetwork() -> Bool {
//        return Reachability.isConnectedToNetwork()
        return false
    }
    
    /// if keyboard poped up
    func keyboardWillShow(notification: NSNotification) {
        keyboardHeight = ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.height)!
    }
    
    func keyboardWillHide(notification: NSNotification) {
        keyboardHeight = ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.height)!
    }
    
    func moveViewForKeyboard(_ control: UIView) {
        if keyboardHeight == 0 {
            delay(delay: 0.3, closure: {
                let delta = self.view.frame.origin.y + self.view.frame.size.height - ((control.superview?.convert(control.frame.origin, to: nil).y)! + control.frame.size.height + self.keyboardHeight)
                if delta < 20 {
                    runOnMain {
                        self.view.frame.origin.y += (delta - 20)
                    }
                }
            })
        } else {
            let delta = self.view.frame.origin.y + self.view.frame.size.height - ((control.superview?.convert(control.frame.origin, to: nil).y)! + control.frame.size.height + self.keyboardHeight)
            if delta < 20 {
                self.view.frame.origin.y += (delta - 20)
            }
        }
    }
    
    func moveViewBack() {
        view.frame.origin.y = viewOriginalTop
    }
    
    private func animateConnectionAlertView() {
        UIView.animate(withDuration: 0.7, animations: { [weak self] in
            self?.noConnectionAlertView.frame = CGRect(x: 0, y: 64, width: (self?.view.frame.size.width)!, height: 20)
            self?.lblNoConnection.frame = CGRect(x:0, y:0, width: (self?.noConnectionAlertView.frame.size.width)!, height: (self?.noConnectionAlertView.frame.size.height)!)
        }) { (_: Bool) in
            delay(delay: 2.0, closure: { 
                UIView.animate(withDuration: 0.7, animations: { [weak self] in
                    self?.noConnectionAlertView.frame = CGRect(x: 0, y: 64, width: (self?.view.frame.size.width)!, height: 0)
                    self?.lblNoConnection.frame = CGRect(x: 0, y: 0, width: (self?.view.frame.size.width)!, height: 0)
                    }, completion: { [weak self] (_: Bool) in
//                        self?.noConnectionAlertView.isHidden = true
                })
            })
        }
    }
}
