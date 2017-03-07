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
        
        // Setup method params
        let methodParameters = [Constants.FlickrParameterKeys.Method: Constants.FlickrParameterValues.GalleryPhotosMethod,
                                Constants.FlickrParameterKeys.APIKey: Constants.FlickrParameterValues.APIKey,
                                Constants.FlickrParameterKeys.GalleryID: Constants.FlickrParameterValues.GalleryID,
                                Constants.FlickrParameterKeys.Extras: Constants.FlickrParameterValues.MediumURL,
                                Constants.FlickrParameterKeys.Format: Constants.FlickrParameterValues.ResponseFormat,
                                Constants.FlickrParameterKeys.NoJSONCallback: Constants.FlickrParameterValues.DisableJSONCallback
                                ]
        
        // Create the URL String
        let methodURL = escapedParameters(methodParameters as [String : AnyObject])
        let urlString = Constants.Flickr.APIBaseURL + methodURL
        
        // Create the URL
        let url = URL(string: urlString)
        
        // Create URL request
        let request = URLRequest(url: url!)
        
        // Create task
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            
            // if an error occurs, print it and re-enable the UI
            func displayError(_ error: String) {
                print(error)
                print("URL at time of error: \(url)")
                performUIUpdatesOnMain {
                    self.setUIEnabled(true)
                }
            }
            
            // no error, woohoo!
            if error == nil {
                
                // there was data returned
                if let data = data {
                    
                    let parsedResult: [String:AnyObject]!
                    do {
                        parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
                    } catch {
                        displayError("Could not parse the data as JSON: '\(data)'")
                        return
                    }
                    
                    // Parse the JSON results
                    if let photosDictionary = parsedResult[Constants.FlickrResponseKeys.Photos] as? [String: AnyObject], let photoArray = photosDictionary[Constants.FlickrResponseKeys.Photo] as? [[String: AnyObject]] {
                        
                        // Pick a random index and create the dictionary for this item
                        let randomPhotoIndex = Int(arc4random_uniform(UInt32(photoArray.count)))
                        let photoDictionary = photoArray[randomPhotoIndex] as [String: AnyObject]
                        
                        // get the URL for the image, and the text for the lable and put them into strings
                        if let imageURLString = photoDictionary[Constants.FlickrResponseKeys.MediumURL] as? String, let photoTitle = photoDictionary[Constants.FlickrResponseKeys.Title] as? String {
                            // Setup image and title on storyboard
                            let imageURL = URL(string: imageURLString)
                            if let imageData = try? Data(contentsOf: imageURL!) {
                                performUIUpdatesOnMain {
                                    self.photoImageView.image = UIImage(data: imageData)
                                    self.photoTitleLabel.text = photoTitle
                                    self.setUIEnabled(true)
                                }
                            }
                        }
                        
                    }
                }
            }
            
        }
        
        task.resume()
        
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
