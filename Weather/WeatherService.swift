import Foundation

// 에러 정의
enum NetworkError: Error {
    case badUrl
    case noData
    case decodingError
}

class WeatherService {
    
    func getWeather(completion: @escaping (WeatherResponse) -> Void) {
        let session = URLSession(configuration: URLSessionConfiguration.default)
        print("getWeather called")
        // API 호출을 위한 URL
        
        let url = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=37.491&lon=126.980&exclude=minutely,daily&appid=eb70946e865f0ed18c6eb6e2a4a39651&units=metric")
        let dataTask = session.dataTask(with: url!){ (data, response, error) in
            guard error == nil else { return }
            guard let resultData = data else { return }
            
            let decoder = JSONDecoder()
            if let response = try? decoder.decode(WeatherResponse.self, from: resultData){
                completion(response)
            }
        }
        dataTask.resume()
    }
}

