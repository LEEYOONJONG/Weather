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
    let weather:[Weather]
}

struct Weather: Decodable{
    let icon:String
}

struct TodayResponse: Decodable{
    let timezone:String
    let lat: Double
    let lon: Double
    let current:Current
    let daily:[Daily]
}
struct Current: Decodable{
    let dt:Int
    let temp:Double
    let weather:[Weather]
}
struct Daily: Decodable{
    let dt:Int
    let temp:Temp
    let weather:[Weather]
}
struct Temp: Decodable{
    let min:Double
    let max:Double
}

struct WeeklyResponse:Decodable{
    let lat: Double
    let lon: Double
    let daily:[Daily]
    
    
}
