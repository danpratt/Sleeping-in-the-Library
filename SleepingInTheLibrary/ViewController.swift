//
//  ViewController.swift
//  SleepingInTheLibrary
//
//  Created by Jarrod Parkes on 11/3/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import UIKit

// MARK: - ViewController: UIViewController

class ViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var photoTitleLabel: UILabel!
    @IBOutlet weak var grabImageButton: UIButton!
    
    // MARK: Actions
    
    @IBAction func grabNewImage(_ sender: AnyObject) {
        setUIEnabled(false)
        getImageFromFlickr()
    }
    
    // MARK: Configure UI
    
    private func setUIEnabled(_ enabled: Bool) {
        photoTitleLabel.isEnabled = enabled
        grabImageButton.isEnabled = enabled
        
        if enabled {
            grabImageButton.alpha = 1.0
        } else {
            grabImageButton.alpha = 0.5
        }
    }
    
    // MARK: Make Network Request
    
    private func getImageFromFlickr() {
        
        // TODO: Write the network code here!
        
    }
    
    private func escapedParameters(_ parameters: [String: AnyObject]) -> String {
        
        if parameters.isEmpty {
            return ""
        } else {
            var keyValuePairs = [String]()
            
            for (key, value) in parameters {
                
                // make sure that it isa  astring value
                let stringValue = "\(value)"
                // escape it
                let escapedValue = stringValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                // apend it
                keyValuePairs.append(key + "=" + "\(escapedValue!)")
            }
            
            return "?\(keyValuePairs.joined(separator: "&"))"
        }
        
        
    }
}
