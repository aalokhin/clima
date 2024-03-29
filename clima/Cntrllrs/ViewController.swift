//
//  ViewController.swift
//  clima
//
//  Created by Anastasiia ALOKHINA on 7/04/19.
//  Copyright © 2019 Anastasiia ALOKHINA. All rights reserved.
//

import UIKit
import RecastAI
import ForecastIO

/*
 so be sure to use a default.
 public enum Icon: String, Decodable {
 
 /// A clear day.
 case clearDay = "clear-day"
 
 /// A clear night.
 case clearNight = "clear-night"
 
 /// A rainy day or night.
 case rain = "rain"
 
 /// A snowy day or night.
 case snow = "snow"
 
 /// A sleety day or night.
 case sleet = "sleet"
 
 /// A windy day or night.
 case wind = "wind"
 
 /// A foggy day or night.
 case fog = "fog"
 
 /// A cloudy day or night.
 case cloudy = "cloudy"
 
 /// A partly cloudy day.
 case partlyCloudyDay = "partly-cloudy-day"
 
 /// A partly cloudy night.
 case partlyCloudyNight = "partly-cloudy-night"
 
}
 
 */


//https://api.darksky.net/forecast/4cf011576b74af281ea89e4702cf6f10/37.8267,-122.4233

class ViewController: UIViewController {
    
   
 
    @IBOutlet weak var resultLbl: UILabel!
    @IBOutlet weak var requestTextField: UITextField!
    
    @IBOutlet weak var iconImage: UIImageView!
    
    
    var bot : RecastAIClient?
    
    var forecastClient : DarkSkyClient?

    override func viewDidLoad() {
        print("hey")
        super.viewDidLoad()
        self.bot = RecastAIClient(token : Client.sharedInstance.recastToken, language: "en")
        self.forecastClient = DarkSkyClient(apiKey: Client.sharedInstance.darkSkySecretKey)
 
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
            resultLbl.text = "Please enter a valid city"
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
            self.resultLbl.text = "Damn it... No such location. Please enter a valid one"
            self.iconImage.image = UIImage(named: "sad")
            
            return
        }
        let lat = Double(truncating: location[0]["lat"] as! NSNumber)
        let long = Double(truncating: location[0]["lng"] as! NSNumber)
        print("\nlocation----->>>", location)
        print("\nlat----->>>>", lat)
        print("\nlng----->>>>", long)
        
        
        //https://darksky.net/dev/docs
        forecastClient?.units = .auto
        forecastClient?.language = .english
        forecastClient?.getForecast(latitude: Double(lat), longitude: long, excludeFields: [.alerts, .daily, .flags, .minutely]) { result in
            switch result {
            case .success(let forecast, _):
                print("success")
                DispatchQueue.main.async{
                    guard let dataReceived = forecast.currently else {
                        self.callErrorWithCustomMessage(message: "No data!")
                        print("No data!")
                        return
                        
                    }
                    let windSpeed = dataReceived.windSpeed?.toString() ?? "No info for wind speed"
                    let temperature = dataReceived.temperature?.toString() ?? "No info for temperature"
                    let pressure = dataReceived.pressure?.toString() ?? "No info for pressure"
                    let humidity = dataReceived.humidity?.toString() ?? "No info for humidity"
                    let summary = dataReceived.summary ?? "No info for  summary"
                    self.resultLbl.text = "Wind speed: \(windSpeed)\n"
                    self.resultLbl.text = self.resultLbl.text! + "Temperature: \(temperature)\n"
                    self.resultLbl.text = self.resultLbl.text! + "Pressure: \(pressure)\n"
                    self.resultLbl.text = self.resultLbl.text! + "Humidity: \(humidity)\n"
                    self.resultLbl.text = self.resultLbl.text! + "Summary: \(summary)\n"
                    guard let img = dataReceived.icon else {
                        self.iconImage.image = nil
                        return
                    }
                    self.iconImage.image = UIImage(named: img.rawValue)
                    self.resultLbl.numberOfLines = 0
                    self.resultLbl.sizeToFit()
                    }
            case .failure(let error):
                print("Error in FOrecast Client")
                self.callErrorWithCustomMessage(message: "Error in FOrecast Client")
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
        self.callErrorWithCustomMessage(message: "Error : \(error)")
    }
    
    
    
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func callErrorWithCustomMessage(message : String) {
        
        let alert = UIAlertController(
            title : "Error",
            message : message,
            preferredStyle : UIAlertControllerStyle.alert
        );
        alert.addAction(UIAlertAction(title: "allright, thank you", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}

extension Double{
    func toString()-> String {
        return String(format: "%.1f",self)
    }
}

