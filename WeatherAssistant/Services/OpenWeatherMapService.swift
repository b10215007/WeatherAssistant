//
//  OpenWeatherMapService.swift
//  WeatherAssistant
//
//  Created by michael on 2018/4/6.
//  Copyright © 2018年 michael. All rights reserved.
//

import Foundation
import CoreLocation

import SwiftyJSON

struct OpenWeatherMapService: WeatherServiceProtocol {

  fileprivate let urlPath = "http://api.openweathermap.org/data/2.5/forecast"

  fileprivate func getFirstFourForecast(_ json: JSON) -> [Forecast]{
    var forecasts: [Forecast] = []

    for index in 0...3{
      guard let forecastTempDegrees = json["list"][index]["main"]["temp"].double,
            let rawDateTime = json["list"][index]["dt"].double,
            let forecastCondition = json["list"][index]["weather"][0]["id"].int,
            let forecastIcon = json["list"][index]["weather"][0]["icon"].string else{
              break
          }
      let country = json["city"]["country"].string
      let forecastTemperature = Temperature(country: country!, openWeatherMapDgree: forecastTempDegrees)
      let forcastTimeString = ForecastDateTime(rawDateTime).showTime
      let weatherIcon = WeatherIcon(condition: forecastCondition, iconString: forecastIcon)
      let forecastIconText = weatherIcon.iconText

      let forecast = Forecast(time: forcastTimeString, iconText: forecastIconText, temperature: forecastTemperature.degrees, temperature_Double: forecastTemperature.degrees_Double, mainWeather: "")
      
      forecasts.append(forecast)
    }

    return forecasts
  }

  fileprivate func getFourDaysForecast(_ json: JSON) -> [Forecast]{
    var forecasts: [Forecast] = []

    for index in 4...39{
      guard let forecastTempDegrees = json["list"][index]["main"]["temp"].double,
            let rawDateTime = json["list"][index]["dt"].double,
            let forecastCondition = json["list"][index]["weather"][0]["id"].int,
            let forecastIcon = json["list"][index]["weather"][0]["icon"].string,
            let forecastWeather = json["list"][index]["weather"][0]["main"].string else{
              break
          }
      let country = json["city"]["country"].string
      let forecastTemperature = Temperature(country: country!, openWeatherMapDgree: forecastTempDegrees)
      let forecastTimeString = ForecastDateTime(rawDateTime).showTime
      let weatherIcon = WeatherIcon(condition: forecastCondition, iconString: forecastIcon)
      let forecastIconText = weatherIcon.iconText
      let main_weather = WeatherDescription(description: forecastWeather)
      let mainWeather = main_weather.describeText

      let forecast = Forecast(time: forecastTimeString, iconText: forecastIconText, temperature: forecastTemperature.degrees, temperature_Double: forecastTemperature.degrees_Double, mainWeather: mainWeather)

      forecasts.append(forecast)
    }
    return forecasts
  }

  func retrieveWeatherInfo(_ location: CLLocation, completionHandler: @escaping WeatherCompletionHandler) {
    let sessionConfig = URLSessionConfiguration.default
    let session = URLSession(configuration: sessionConfig)

    guard let url = generateRequestURL(location) else{
      let error = SWError(errorCode: .urlError)
      completionHandler(nil, error)
      return
    }

    print(url)
    let task = session.dataTask(with: url) { (data, response, error) in
      //check Network error
      guard error == nil else {
        let error = SWError(errorCode: .networkRequestFailed)
        completionHandler(nil, error)
        return
      }

      // Check JSON serialization error
      guard let data = data else {
        let error = SWError(errorCode: .jsonSerializationFailed)
        completionHandler(nil, error)
        return
      }

      guard let json = try? JSON(data: data) else{
        let error = SWError(errorCode: .jsonParsingFailed)
        completionHandler(nil, error)
        return
      }

      // Get temperature, location and icon and check parsing error
      guard let tempDegrees = json["list"][0]["main"]["temp"].double,
            let country = json["city"]["country"].string,
            let city = json["city"]["name"].string,
            let weatherCondition = json["list"][0]["weather"][0]["id"].int,
            let iconString = json["list"][0]["weather"][0]["icon"].string,
            let weatherDescribe = json["list"][0]["weather"][0]["description"].string,
            let main_weather = json["list"][0]["weather"][0]["main"].string
        else{
              let error = SWError(errorCode: .jsonParsingFailed)
              completionHandler(nil,error)
              return}

      var weatherBuilder = WeatherBuilder()
      let temperature = Temperature(country: country, openWeatherMapDgree: tempDegrees)
      weatherBuilder.location = city
      weatherBuilder.temperature = temperature.degrees
      weatherBuilder.temperature_Double = temperature.degrees_Double

      let weatherDescription = WeatherDescription(description: weatherDescribe)
      let mainWeatherText = WeatherDescription(description: main_weather)
      weatherBuilder.description = weatherDescription.describeText
      weatherBuilder.mainWeather = mainWeatherText.describeText

      let weatherIcon = WeatherIcon(condition: weatherCondition, iconString: iconString)
      weatherBuilder.iconText = weatherIcon.iconText

      weatherBuilder.forecasts = self.getFirstFourForecast(json)
      weatherBuilder.forecast4Days = self.getFourDaysForecast(json)

      completionHandler(weatherBuilder.build(), nil)
    }

    task.resume()
  }


  fileprivate func generateRequestURL(_ location: CLLocation) -> URL?{
    guard var components = URLComponents(string: urlPath) else {
      return nil
    }
    //網站申請的appid
    let myAppId = ""

    //latitude: 緯度 longitude:經度
    let latitude = String(location.coordinate.latitude)
    let longtitude = String(location.coordinate.longitude)

    components.queryItems = [URLQueryItem(name: "lat", value: latitude),
                             URLQueryItem(name: "lon", value: longtitude),
                             URLQueryItem(name: "appId", value: myAppId)]
    return components.url
  }

}

