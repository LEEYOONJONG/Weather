import Foundation

struct WeatherResponse: Decodable {
    let timezone: String
    let lat: Double
    let lon: Double
    let hourly: [Hourly]
}

struct Hourly: Decodable{
    let dt:Int
    let temp:Double
    let humidity:Int
}
