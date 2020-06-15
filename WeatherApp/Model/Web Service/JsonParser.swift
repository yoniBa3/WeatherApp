//
//  JsonParser.swift
//  WeatherApp
//
//  Created by Yoni on 13/06/2020.
//  Copyright © 2020 Yoni. All rights reserved.
//

import Foundation
class JsonParser{
     static let shared = JsonParser()
    private init(){}
    
    //Mark: API_KEY
    private let API_KEY = "&appid=39208bc33a618f456ff1567af1a53c0c"
    
    //MARK: Url for current cities weather data
    private let URL_FOR_CURRENT_WEATHER_DATA = "https://api.openweathermap.org/data/2.5/group?id={city id}&units=metric"
    
    //MARK: Url for weekly city data
    private let URL_FOR_WEEKLY_WEATHER_DATA = "https://api.openweathermap.org/data/2.5/forecast?id={city id}&units=metric"
    
    
     func fecthWeather<T:Codable>(with citiesId:[Int] ,request:RequestForCall ,complation:@escaping(T) -> ()){
        let urlString = getUrlstring(with: citiesId, requst: request)
        guard let url = URL(string: urlString) else{return}
        let seesion = URLSession.shared
        seesion.dataTask(with: url, completionHandler: { (data, res, err) in
            do{
                guard let data = data else{return}
                           let decoder = JSONDecoder()
                let object = try decoder.decode(T.self, from: data)
                complation(object)
            }catch{
                print(error)
            }
            
        }).resume()
    }
    
    
    private func getUrlstring(with citiesId:[Int] ,requst:RequestForCall) -> String{
        var urlString = ""
        switch requst{
        case.current:
            urlString = URL_FOR_CURRENT_WEATHER_DATA
        case.weekly:
            urlString = URL_FOR_WEEKLY_WEATHER_DATA
        }
        let citiesIdString = String(citiesId.map({
            String($0)
            }).joined(separator: ","))

        return urlString.replacingOccurrences(of: "{city id}", with: citiesIdString)+API_KEY
        
    }
}
enum RequestForCall{
    case current ,weekly
}
