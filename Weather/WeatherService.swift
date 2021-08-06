import Foundation

// 에러 정의
enum NetworkError: Error {
    case badUrl
    case noData
    case decodingError
}

class WeatherService {
    
    func getWeather(completion: @escaping (WeatherResponse) -> Void) {
        
    }
}

