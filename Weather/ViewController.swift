//
//  ViewController.swift
//  Weather
//
//  Created by YOONJONG on 2021/08/01.
//

import UIKit
import Foundation
class ViewController: UIViewController {
    
    @IBOutlet weak var todayImage: UIImageView!
    @IBOutlet weak var nowTempLabel: UILabel!
    @IBOutlet weak var highTempLabel: UILabel!
    @IBOutlet weak var lowTempLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        fetchToday()
        
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
    
    func fetchToday(){
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let url = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=37.491&lon=126.980&exclude=minutely&appid=\(apiKey)&units=metric")
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

