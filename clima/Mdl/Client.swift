//
//  Client.swift
//  clima
//
//  Created by Anastasiia ALOKHINA on 6/27/19.
//  Copyright © 2019 Anastasiia ALOKHINA. All rights reserved.
//

import Foundation
//https://api.darksky.net/forecast/4cf011576b74af281ea89e4702cf6f10/37.8267,-122.4233

final class Client {
    let recastToken = "9c9b8d3d791e63e2d64049939fe5ff0e"
    let darkSkySecretKey = "4cf011576b74af281ea89e4702cf6f10"
    
    static let sharedInstance = Client()
    
    
    private init(){
        
        print("Singleton client has been initialized")
       
    }
}
