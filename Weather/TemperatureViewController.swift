//
//  TemperatureViewController.swift
//  Weather
//
//  Created by YOONJONG on 2021/08/03.
//

import UIKit
import Foundation

class TemperatureViewController: UIViewController {

    @IBOutlet weak var temperatureCollectionView: UICollectionView!
    
    let viewModel = HourlyViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
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
    
    func update(info:Hourly){
        timeLabel.text = "\(info.dt)"
        temperatureLabel.text = "\(info.temp)"
    }
}

class HourlyViewModel {
    var HourlyList:[Hourly]=[]
    func fetchData() -> Void{
        WeatherService().getWeather { result in
            print("위도 : \(result.lat), 경도 : \(result.lon)")
//            print("--> ", result.hourly)
            let hourlyCnt:Int = result.hourly.count
            for i in 0..<hourlyCnt{
                print("\(i)번째 data : \(result.hourly[i])")
//                let date = Date(timeIntervalSince1970: TimeInterval(result.hourly[i].dt))
//                let dateFormatter = DateFormatter()
//                dateFormatter.timeZone = TimeZone(abbreviation: "KST")
//                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
//                let stringDate = dateFormatter.string(from: date) // UNIX timestamp 형식을 KST로 변환
//                print("date: ", stringDate)
                self.HourlyList.append(Hourly(dt: result.hourly[i].dt, temp: result.hourly[i].temp, humidity: result.hourly[i].humidity))
            }
        }
    }
}
private var apiKey:String{
    get {
        guard let filePath = Bundle.main.path(forResource: "KeyList", ofType: "plist")
        else { fatalError("Couldnt find file 'KeyList.plist !!") }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "OPENWEATHERMAP_KEY") as? String else {
            fatalError("Couldn't find key 'Openweathermap_key' in Keylist.plist")
        }
        return value;
    }
}
