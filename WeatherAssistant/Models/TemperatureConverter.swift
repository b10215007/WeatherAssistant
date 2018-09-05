//
//  TemperatureConvert.swift
//  WeatherAssistant
//
//  Created by michael on 2018/4/6.
//  Copyright © 2018年 michael. All rights reserved.
//

import Foundation


struct TemperatureConverter {

  static func kelvinToCelsius(_ degree: Double) -> Double{
    return round(degree - 273.15)
  }

  static func kelvinToFahrenheit(_ degree: Double) -> Double{
    return round(degree * 9 / 5 - 459.67)
  }

}
