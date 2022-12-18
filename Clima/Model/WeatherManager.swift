//
//  WeatherManager.swift
//  Clima
//
//  Created by Odinachi David on 08/09/2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

protocol WeatherManagerDelegate
{
    func didUpdate(_ weatherManager: WeatherManager, updatedData: WeatherModel)
    func didFail (error: Error?)
}

import Foundation
import CoreLocation

struct WeatherManager {
    var city = ""
    var temp = 0
    var weatherUrl = "https://api.openweathermap.org/data/2.5/weather?&appid=8263c6b6a7c1b02657e1a6e28fb0caab&q="
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String?){
        
        if let city = cityName {
            let url = URL(string: "\(weatherUrl)\(city)")
            
            let urlSession = URLSession(configuration: .default)
            let call = urlSession.dataTask(with: url! ) {(data, error, response) in
                if let error = error {
                    self.delegate?.didFail(error: error as? Error)
            }
            
                if let data = data {
                    if let weather =
                        self.parseJson(data: data){
                        
                        self.delegate?.didUpdate(self, updatedData: weather)
                    }
                    
                }
                
            }
            
            call.resume()
            
        }
    }
    
    func parseJson (data: Data)-> WeatherModel? {
        let decoder = JSONDecoder()
        
        do{
           let weatherdata =  try decoder.decode(WeatherData.self, from: data)
        
            let w = WeatherModel(id: weatherdata.weather[0].id, city: weatherdata.name, temp: weatherdata.main.temp)
        
            return w
        }catch {
            
            self.delegate?.didFail(error: error)
        }
        return nil
    }
   
}

extension WeatherManager{
  func fetchWeather(lat: CLLocationDegrees, lon: CLLocationDegrees){
    let  url =
      
     URL(string: "https://api.openweathermap.org/data/2.5/weather?&appid=8263c6b6a7c1b02657e1a6e28fb0caab&lat=\(lat)&lon=\(lon)")
    
          
          let urlSession = URLSession(configuration: .default)
          let call = urlSession.dataTask(with: url! ) {(data, error, response) in
              if let error = error {
                  self.delegate?.didFail(error: error as? Error)
          }
          
              if let data = data {
                  if let weather =
                      self.parseJson(data: data){
                    
                      self.delegate?.didUpdate(self, updatedData: weather)
                  }
                  
              }
              
          }
          
          call.resume()
    }
}
