//
//  ViewController.swift
//  Weather
//
//  Created by YOONJONG on 2021/08/01.
//

import UIKit
import Foundation
import CoreLocation
class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var todayImage: UIImageView!
    @IBOutlet weak var nowTempLabel: UILabel!
    @IBOutlet weak var highTempLabel: UILabel!
    @IBOutlet weak var lowTempLabel: UILabel!
    
    var locationManager:CLLocationManager?
    var currentLocation:CLLocationCoordinate2D!
    var latitude:Double?
    var longitude:Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        requestAuthorization()
        
        
    }
    private func requestAuthorization(){
        if locationManager == nil {
            print("nil 진입")
            locationManager = CLLocationManager()
            locationManager!.delegate = self
            locationManager!.requestWhenInUseAuthorization()
            locationManager!.desiredAccuracy = kCLLocationAccuracyBest
            locationManagerDidChangeAuthorization(locationManager!)
        } else {
            print("not nil일 때")
            locationManager!.startMonitoringSignificantLocationChanges()
        }
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse {
            currentLocation = locationManager!.location?.coordinate
            LocationService.shared.longitude = currentLocation.longitude
            LocationService.shared.latitude = currentLocation.latitude
            print("---> ", LocationService.shared.longitude!, LocationService.shared.latitude!)
            if let lon = LocationService.shared.longitude, let lat = LocationService.shared.latitude {
                fetchToday(lat, lon)
                //
                let findLocation = CLLocation(latitude: lat, longitude: lon)
                let geocoder = CLGeocoder()
                let locale = Locale(identifier: "Ko-kr") //원하는 언어의 나라 코드를 넣어주시면 됩니다.
                geocoder.reverseGeocodeLocation(findLocation, preferredLocale: locale, completionHandler: {(placemarks, error) in
                    if let address: [CLPlacemark] = placemarks {
                        // 주소를 String으로
                        let locationString = String("\(address.last!.administrativeArea!) \(address.last!.locality!) \(address.last!.thoroughfare!)")
                        self.locationLabel.text = locationString
                        
                    }
                })
            }
        }
    }
}
extension ViewController{
    private var apiKey:String{
        get {
            guard let filePath = Bundle.main.path(forResource: "Property List", ofType: "plist")
            else { return "" }
            let plist = NSDictionary(contentsOfFile: filePath)
            print("plist : ",plist)
            guard let value = plist?.object(forKey: "OPENWEATHERMAP_KEY") as? String else { return "" }
            return value
        }
    }
    
    func fetchToday(_ lat:Double, _ lon:Double){
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let url = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&exclude=minutely&appid=\(apiKey)&units=metric")
        print("->", url)
        let dataTask = session.dataTask(with: url!){(data, response, error) in
            guard error == nil else { return }
            guard let resultData = data else { return }
            print("ResultData : \(resultData)")
            //            print(String(decoding:data!, as:UTF8.self))
            let decoder = JSONDecoder()
            if let response = try? decoder.decode(TodayResponse.self, from: resultData){
                print("today : \(response)")
                DispatchQueue.main.sync {
                    self.todayImage.image = UIImage(named: "\(response.current.weather[0].icon)@4x.png")
                    self.nowTempLabel.text = "\(response.current.temp)º"
                    self.highTempLabel.text = "최고 : \(response.daily[0].temp.max)º"
                    self.lowTempLabel.text = "최저 : \(response.daily[0].temp.min)º"
                }
                
            }
            
            
        }
        dataTask.resume()
    }
}

class LocationService {
    static var shared = LocationService()
    var longitude:Double!
    var latitude:Double!
}
