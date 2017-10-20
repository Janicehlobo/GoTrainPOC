//
//  ImageRecognizerVC.swift
//  GoTrainPOC
//
//  Created by Bahram Haddadi on 2017-10-12.
//  Copyright © 2017 Bahram Haddadi. All rights reserved.
//

import UIKit
import MobileCoreServices
import Vision
import CoreLocation

class ImageRecognizerVC: BaseVC, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate, UITextFieldDelegate {
    @IBOutlet var imgPhoto: UIImageView!
    @IBOutlet var vwCategoryPicker: UIView!
    @IBOutlet var pickerCategory: UIPickerView!
    @IBOutlet var btnCategory: UIButton!
    @IBOutlet var btnCamera: UIButton!
    @IBOutlet var btnEdit: UIButton!
    @IBOutlet var btnPostToServer: RoundedBotton!
    @IBOutlet var txtNote: UITextField!
    @IBOutlet var constraintContentTop: NSLayoutConstraint!
    @IBOutlet var lblEmotion: UILabel!
    
    let model = GoogLeNetPlaces()
    var categories: Categories?
    var request: VNCoreMLRequest?
    typealias Prediction = (String, Double)
    var locationManeger = CLLocationManager()
    var currentLocation: CLLocation?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.categories = Categories()
        self.pickerCategory.reloadAllComponents()
        self.locationManeger.delegate = self
        self.locationManeger.requestLocation()
        self.locationManeger.requestWhenInUseAuthorization()
        self.locationManeger.startUpdatingLocation()
        
        guard let visionModel = try? VNCoreMLModel(for: model.model) else {
            fatalError("Error")
        }
        
        self.request = VNCoreMLRequest(model: visionModel) { request, error in
            if let observations = request.results as? [VNClassificationObservation] {
                let top5 = observations.prefix(through: 4)
                    .map { ($0.identifier, Double($0.confidence)) }
                self.show(results: top5)
                self.btnPostToServer.isEnabled = true
            }
        }
    }

    //MARK: - IBActions
    @IBAction func btnCategory_click(_ sender: Any) {
        vwCategoryPicker.isHidden = false
    }
    
    @IBAction func btnPostToServer_click(_ sender: Any) {
       
        showSpinner(show: true)
        NetworkUtilities.postImageToServer(image: imgPhoto.image!, location: self.currentLocation ?? CLLocation(), note: txtNote.text!, category: (categories?.categories.first)!) { (error) in
            self.showSpinner(show: false)
            if error != nil {
                self.showToast(message: (error?.localizedDescription)!, style: .error)
            } else {
                self.showToast(message: "Data posted successfully", style: .information)
            }
        }
        
        NetworkUtilities.sentimentalAnalysis(text: self.txtNote.text!) { [weak self] (error, score,toneName) in
            print(toneName)
            
            DispatchQueue.main.async {
                switch(toneName) {
                case "Anger":
                    self?.lblEmotion.text =  "\u{1F621}"
                case "Sadness":
                    self?.lblEmotion.text =  "\u{1F61E}"
                default:
                    self?.lblEmotion.text = "\u{1F603}"
                }
            }
        }
    }
    
    @IBAction func btnCamera_Click(_ sender: Any) {
        let title = NSLocalizedString("Choose your source", comment: "")
        let message = NSLocalizedString("Please choose your source", comment: "")
        let camera = NSLocalizedString("Camera", comment: "")
        let cancel = NSLocalizedString("Cancel", comment: "")
        let photoLibrary = NSLocalizedString("Photo Library", comment: "")
        let actionSheet = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: camera, style: .default, handler: { (action) in
            print("user selected camera")
            self.choosePhoto(source: .camera)
        }))
        
        actionSheet.addAction(UIAlertAction(title: photoLibrary, style: .default, handler: { (alert) in
            print("user selected photo library")
            self.choosePhoto(source: .photoLibrary)
        }))

        actionSheet.addAction(UIAlertAction(title: cancel, style: .cancel, handler: { (alert) in
            self.dismiss(animated: true, completion: nil)
        }))

        present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func btnEdit_Click(_ sender: Any) {
        txtNote.text = " "
        lblEmotion.text = " "
        btnCategory.setTitle("Category", for: .normal)
        
        btnCamera_Click(sender)
    }
    
    @IBAction func pickerBackground_tap(_ sender: Any) {
        vwCategoryPicker.isHidden = true
    }
    
    //MARK: - Helper Methods
    // Choose a photo and predict the image category.
    //
    /// - Parameter source: this is source of image , it can be camera or photo library
    func choosePhoto(source: UIImagePickerControllerSourceType) {
        if source == .camera {
            if UIImagePickerController.isSourceTypeAvailable(.camera) == false {
                showToast(message: "Camera is not available", style: .error)
                return
            }
        }
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        imagePicker.mediaTypes = [kUTTypeImage as String]
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    /// A prediction model
    ///
    /// - Parameter results: predicts the category of the image and displays it on the screen, showing the top 5 matches for the image
    func show(results: [Prediction]) {
        if let category = self.categories?.findCategory(value: (results.first?.0)!) {
            let row = self.categories?.categories.index(of: category) ?? 0
            self.pickerCategory.selectRow(row, inComponent: 0, animated: true)
            btnCategory.setTitle(category.name, for: .normal)
            btnPostToServer.isEnabled = true
        }
        var s: [String] = []
        for (i, pred) in results.enumerated() {
            s.append(String(format: "%d: %@ (%3.2f%%)", i + 1, pred.0, pred.1 * 100))
        }
        print ( s.joined(separator: "\n"))
        showInfoMessage(title: "info", message: s.joined(separator: "\n"))
    }

    /// Performs the recognition 
    func recognizeImage() {
        guard let request = self.request else {
            return
        }
        let handler = VNImageRequestHandler(cgImage: self.imgPhoto.image!.cgImage!)
        try? handler.perform([request])
    }
    
    /// Get the current location of the user
    ///
    /// - Parameter lastLocation: this is last locatio detected by phone
    func lookUpCurrentLocation(lastLocation: CLLocation) {
        let geocoder = CLGeocoder()
            // Look up the location and pass it to the completion handler
        geocoder.reverseGeocodeLocation(lastLocation, completionHandler: { (placemarks, error) in
                                            if error == nil {
                                                //print(placemarks?.first?.locality)
                                            }
                                            else {
                                                //print("cannot get address")
                                            }
        })
    }
    
    //MARK: - Picker Delegates
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.categories?.categories.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.categories?.categories[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        vwCategoryPicker.isHidden = true
        btnCategory.setTitle(categories?.categories[row].name, for: .normal)
    }
    
    //MARK: UIImageView Delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imgPhoto.image = info[UIImagePickerControllerOriginalImage] as? UIImage //?? UIImage()
        dismiss(animated: true, completion: nil)
        btnEdit.isHidden = false
        btnCamera.isHidden = true
        recognizeImage()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("User canceleed")
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - CLLocationManager delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let loc = locations.first {
            self.currentLocation = loc
            lookUpCurrentLocation(lastLocation: loc)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    //MARK: - TextFeild delegates
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("done typing")
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        self.constraintContentTop.constant = 150
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        self.constraintContentTop.constant = 0
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
        }
        return true
    }
}
