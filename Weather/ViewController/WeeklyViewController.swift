//
//  WeeklyViewController.swift
//  Weather
//
//  Created by YOONJONG on 2021/08/17.
//

import UIKit
import Foundation
import CoreLocation

class WeeklyViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var weeklyCollectionView: UICollectionView!
    
    var locationManager:CLLocationManager?
    var currentLocation:CLLocationCoordinate2D!
    
    let viewModel = WeeklyViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        weeklyCollectionView.delegate = self
        requestAuthorization()
        // Do any additional setup after loading the view.
    }
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
            
            if let lon = LocationService.shared.longitude, let lat = LocationService.shared.latitude {
                fetchWeather(lat, lon)
                
            }
        }
    }
    
    func fetchWeather(_ lat:Double, _ lon:Double){
        let session = URLSession(configuration: URLSessionConfiguration.default)
        print("weeklyVC getWeather called")
        // API 호출을 위한 URL
        
        let url = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&exclude=minutely&appid=\(apiKey)&units=metric")
        print("=> weeklyURL = ",url)
        let dataTask = session.dataTask(with: url!){ (data, response, error) in
//            print("weekly dataTask 진입")
//            print("=> data : ", data)
            guard error == nil else { return }
            guard let resultData = data else { return }
            let str = String(decoding: resultData, as: UTF8.self)
//            print("==> : ", str)
            let decoder = JSONDecoder()
            if let response = try? decoder.decode(WeeklyResponse.self, from: resultData){
                let WeeklyCnt:Int = response.daily.count
                print("weeklycnt : \(WeeklyCnt)")
                self.viewModel.WeeklyList.removeAll() // 어쩔 수 없이..
                for i in 0..<WeeklyCnt{
//                    print("\(i)번째 data : \(response.hourly[i])")
                    self.viewModel.WeeklyList.append(Daily(dt: response.daily[i].dt, temp: response.daily[i].temp, weather: response.daily[i].weather))
                }
                DispatchQueue.main.sync{
                    self.weeklyCollectionView.reloadData()
                }
            }

        }
        dataTask.resume()
    }
   
}
extension WeeklyViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("------- list count : ", viewModel.WeeklyList.count)
        return viewModel.WeeklyList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeeklyCell", for: indexPath) as? WeeklyCell else { return UICollectionViewCell() }
        let info = viewModel.WeeklyList[indexPath.item]
        cell.update(info:info)
        return cell;
    }
}
extension WeeklyViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width:CGFloat = 360
        let height:CGFloat = 360
        let cellHeight:CGFloat = height/CGFloat(viewModel.WeeklyList.count)
        return CGSize(width: width, height: cellHeight)
    }
}

class WeeklyCell: UICollectionViewCell{
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weatherLabel: UIImageView!
    @IBOutlet weak var hightempLabel: UILabel!
    @IBOutlet weak var lowtempLabel: UILabel!
    
    func update(info:Daily){
        let date = Date(timeIntervalSince1970: TimeInterval(info.dt))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "E"
        let stringDate = dateFormatter.string(from: date) // UNIX timestamp 형식을 KST로 변환
//        print("--> weather icon : \(info.weather[0].icon)")
        
        weatherLabel.image = UIImage(named: "\(info.weather[0].icon)@4x.png")
        hightempLabel.text = "\(Int(info.temp.max))º"
        lowtempLabel.text = "\(Int(info.temp.min))º"
        dayLabel.text = "\(stringDate)요일"
    }
    
}
class WeeklyViewModel {
    var WeeklyList:[Daily]=[]
    
}

