//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet var searchField: UITextField!
    
    var weatherManager = WeatherManager()
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        locationManager.requestLocation()
      
        
        searchField.delegate = self
        
    }
    
    
    
  
    
}


//MARK: - Current Location
extension WeatherViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
          if status == .authorizedWhenInUse {
              locationManager.requestLocation()
          }
      }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
           print("error:: \(error.localizedDescription)")
      }
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//
//
//        if let last = locations.last{
//
//            weatherManager.fetchWeather(lat: last.coordinate.latitude, lon: last.coordinate.longitude)
//        }
//    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last {
            let geocoder = CLGeocoder()
                    weatherManager.fetchWeather(lat: lastLocation.coordinate.latitude, lon: lastLocation.coordinate.longitude)

            geocoder.reverseGeocodeLocation(lastLocation) { [weak self] (placemarks, error) in
                if error == nil {
                    if let firstLocation = placemarks?[0],
                        let cityName = firstLocation.locality {
                      print(cityName)
                        self?.locationManager.stopUpdatingLocation()
                    }
                }
            }
        }
    }
}

//MARK: - UITextField
extension WeatherViewController:UITextFieldDelegate{
    @IBAction func searchPress(_ sender: UIButton) {
        searchField.endEditing(true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something here"
            return false
        }
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = textField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        
        textField.text = ""
    }
    
    
}



//MARK: - Waether Manager Delegate
extension WeatherViewController: WeatherManagerDelegate {
    func didUpdate(_ weatherManager: WeatherManager, updatedData: WeatherModel) {
    
        DispatchQueue.main.async {

            self.cityLabel.text = updatedData.city
            self.temperatureLabel.text = updatedData.tempString
            self.conditionImageView.image = UIImage(systemName: updatedData.conditionName)
        }
        
        
        
    }
    
    func didFail(error: Error?) {
        print("error is \(String(describing: error))")
    }
}
