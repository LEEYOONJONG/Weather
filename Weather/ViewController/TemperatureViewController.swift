//
//  TemperatureViewController.swift
//  Weather
//
//  Created by YOONJONG on 2021/08/03.
//

import UIKit
import Foundation
import CoreLocation

class TemperatureViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var temperatureCollectionView: UICollectionView!
    
    let viewModel = HourlyViewModel()
    
    var locationManager:CLLocationManager?
    var currentLocation:CLLocationCoordinate2D!
    
    
    private var apiKey:String{
        get {
            guard let filePath = Bundle.main.path(forResource: "Property List", ofType: "plist")
            else { return "" }
            let plist = NSDictionary(contentsOfFile: filePath)
//            print("plist : ",plist)
            guard let value = plist?.object(forKey: "OPENWEATHERMAP_KEY") as? String else { return "" }
            return value
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        temperatureCollectionView.delegate = self
//        fetchWeather()
        requestAuthorization()
    }
    private func requestAuthorization(){
        if locationManager == nil {
//            print("nil 진입")
            locationManager = CLLocationManager()
            locationManager!.delegate = self
            locationManager!.requestWhenInUseAuthorization()
            locationManager!.desiredAccuracy = kCLLocationAccuracyBest
            locationManagerDidChangeAuthorization(locationManager!)
        } else {
//            print("not nil일 때")
            locationManager!.startMonitoringSignificantLocationChanges()
        }
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse {
            currentLocation = locationManager!.location?.coordinate
            LocationService.shared.longitude = currentLocation.longitude
            LocationService.shared.latitude = currentLocation.latitude
//            print("---> ", LocationService.shared.longitude!, LocationService.shared.latitude!)
            if let lon = LocationService.shared.longitude, let lat = LocationService.shared.latitude {
                fetchWeather(lat, lon)
                
            }
        }
    }
    // api call
    func fetchWeather(_ lat:Double, _ lon:Double){
        let session = URLSession(configuration: URLSessionConfiguration.default)
//        print("getWeather called")
        // API 호출을 위한 URL
        
        let url = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&exclude=minutely,daily&appid=\(apiKey)&units=metric")
        let dataTask = session.dataTask(with: url!){ (data, response, error) in
            guard error == nil else { return }
            guard let resultData = data else { return }
            
            let decoder = JSONDecoder()
            if let response = try? decoder.decode(WeatherResponse.self, from: resultData){
                let hourlyCnt:Int = response.hourly.count
                for i in 0..<hourlyCnt{
//                    print("\(i)번째 data : \(response.hourly[i])")
                    self.viewModel.HourlyList.append(Hourly(dt: response.hourly[i].dt, temp: response.hourly[i].temp, humidity: response.hourly[i].humidity, weather: response.hourly[i].weather))
                }
                DispatchQueue.main.sync{
                    self.temperatureCollectionView.reloadData()
                }
                
            }
        }
        dataTask.resume()
    }
}

extension TemperatureViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.HourlyList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TemperatureCell", for: indexPath) as? TemperatureCell else { return UICollectionViewCell() }
        let info = viewModel.HourlyList[indexPath.item]
        cell.update(info:info)
        return cell;
    }
    
    
}

extension TemperatureViewController: UICollectionViewDelegate {
    // 필요없을듯. 클릭했을때의 동작
}


class TemperatureCell: UICollectionViewCell {
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    
    func update(info:Hourly){
        let date = Date(timeIntervalSince1970: TimeInterval(info.dt))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.locale = Locale(identifier: "ko_KR")
//        dateFormatter.dateFormat = "d일 (E) HH시"
        dateFormatter.dateFormat = "E요일 HH시"
        let stringDate = dateFormatter.string(from: date) // UNIX timestamp 형식을 KST로 변환
//        print("--> weather icon : \(info.weather[0].icon)")
        
        weatherImage.image = UIImage(named: "\(info.weather[0].icon)@4x.png")
        timeLabel.text = "\(stringDate)"
        temperatureLabel.text = "\(Int(info.temp))º"
        humidityLabel.text = "\(info.humidity)%"
    }
}

class HourlyViewModel {
    var HourlyList:[Hourly]=[]
    
}

