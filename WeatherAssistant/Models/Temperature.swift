//
//  Temperature.swift
//  WeatherAssistant
//
//  Created by michael on 2018/4/6.
//  Copyright © 2018年 michael. All rights reserved.
//

import Foundation


struct Temperature {
  let degrees: String
  let degrees_Double: Double

  init(country: String, openWeatherMapDgree: Double) {
    if country == "US"{
      degrees = String(TemperatureConverter.kelvinToFahrenheit(openWeatherMapDgree)) + "\u{f045}"
      degrees_Double = TemperatureConverter.kelvinToFahrenheit(openWeatherMapDgree)
    }else{
      degrees = String(TemperatureConverter.kelvinToCelsius(openWeatherMapDgree)) + "\u{f03c}"
      degrees_Double = TemperatureConverter.kelvinToCelsius(openWeatherMapDgree)
    }
  }
}
