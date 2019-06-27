//
//  ViewController.swift
//  clima
//
//  Created by Anastasiia ALOKHINA on 6/27/19.
//  Copyright © 2019 Anastasiia ALOKHINA. All rights reserved.
//

import UIKit
import RecastAI
import ForecastIO


//https://api.darksky.net/forecast/4cf011576b74af281ea89e4702cf6f10/37.8267,-122.4233

class ViewController: UIViewController {
    
   
 
    @IBOutlet weak var resultLbl: UILabel!
    @IBOutlet weak var requestTextField: UITextField!
    
    var bot : RecastAIClient?
    
    var forecastClient : DarkSkyClient?

    override func viewDidLoad() {
        print("hey")
        super.viewDidLoad()
        self.bot = RecastAIClient(token : Client.sharedInstance.recastToken, language: "en")
        self.forecastClient = DarkSkyClient(apiKey: Client.sharedInstance.darkSkySecretKey)
        
        

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    @IBAction func getWeather(_ sender: UIButton) {
        
        print("button pressed")
        
        
        if (!(self.requestTextField.text?.isEmpty)!)
        {
            print("your request has been sent")

            self.bot?.textRequest(self.requestTextField.text!, successHandler: recastRequestDone, failureHandle: recastRequestError)
        }
        else{
            print("empty field no reuest has been sent")
        }
    }
    
    
    
    /**
     Method called when the request was successful
     - parameter response: the response returned from the Recast API
     - returns: void
     */
    
    func recastRequestDone(_ response : Response)
    {
        print(response.timestamp as Any)
        print(response.status as Any)
        print(response.intents as Any)
        print(response.language as Any)
        print(response.source as Any)
        
        guard let location = response.entities!["location"] as? [[String: Any]] else {
            print("No location found")
            resultLbl.text = "No such location. Please enter a valid one"
            
            return
        }
        let lat = Double(truncating: location[0]["lat"] as! NSNumber)
        let long = Double(truncating: location[0]["lng"] as! NSNumber)
        print("\nlocation----->>>", location)
        print("\nlat----->>>>", lat)
        print("\nlng----->>>>", long)
        
        forecastClient?.units = .auto
        forecastClient?.language = .english
        
        forecastClient?.getForecast(latitude: Double(lat), longitude: long, excludeFields: [.alerts, .currently, .daily, .flags, .minutely]) { result in
            switch result {
            case .success(let forecast, let requestMetadata):
                print("success")
               // print(forecast.hourly!.data)
                //print(requestMetadata)
            case .failure(let error):
                print("Error in FOrecast Client")
                print(error)
            }
        }
    }
    

 
    
    /**
     Method called when the request failed
     
     - parameter error: error returned from the Recast API
     
     - returns: void
     */
    func recastRequestError(_ error : Error)
    {
        print("Error : \(error)")
    }
    
    
    
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   


}

