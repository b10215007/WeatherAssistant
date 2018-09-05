//
//  Weather.swift
//  WeatherAssistant
//
//  Created by michael on 2018/4/6.
//  Copyright © 2018年 michael. All rights reserved.
//

import Foundation

struct Weather {
  let location           :String
  let iconText           :String
  let temperature        : String
  let temperature_Double : Double
  let description        : String
  let mainWeather        : String

  let forecast      : [Forecast]
  let forecast4Days : [Forecast]
}
