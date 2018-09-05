//
//  WeatherBuilder.swift
//  WeatherAssistant
//
//  Created by michael on 2018/4/6.
//  Copyright © 2018年 michael. All rights reserved.
//

import Foundation


struct WeatherBuilder {
  var location: String?
  var iconText: String?
  var temperature: String?
  var temperature_Double:  Double?
  var description: String?
  var mainWeather: String?

  var forecasts: [Forecast]?
  var forecast4Days  : [Forecast]?

  func build() -> Weather{
    return Weather(location: location!, iconText: iconText!, temperature: temperature!, temperature_Double: temperature_Double!, description: description!, mainWeather: mainWeather!, forecast: forecasts!, forecast4Days: forecast4Days!)
  }
}
