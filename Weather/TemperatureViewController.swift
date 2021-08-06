//
//  TemperatureViewController.swift
//  Weather
//
//  Created by YOONJONG on 2021/08/03.
//

import UIKit

class TemperatureViewController: UIViewController {

    let viewModel = HourlyViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchData()
    }
    
}

extension TemperatureViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TemperatureCell", for: indexPath) as? TemperatureCell else { return UICollectionViewCell() }
        // let info = viewmodel.info(At:indexpath.item)
        // cell.update(info:info)
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
    
}

class HourlyViewModel {
    var HourlyList:[Hourly]=[]
    func fetchData(){
        WeatherService().getWeather { result in
            print("위도 : \(result.lat), 경도 : \(result.lon)")
//            print("--> ", result.hourly)
            let hourlyCnt:Int = result.hourly.count
            for i in 0..<hourlyCnt{
                print("\(i)번째 data : \(result.hourly[i])")
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
