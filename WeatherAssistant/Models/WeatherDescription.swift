//
//  WeatherDescription.swift
//  WeatherAssistant
//
//  Created by michael on 2018/4/8.
//  Copyright © 2018年 michael. All rights reserved.
//

import Foundation

struct WeatherDescription{
  var describeText: String

  enum describeType: String, CustomStringConvertible {
    case clear_sky        = "clear sky"
    case scattered_clouds = "scattered clouds"
    case broken_clouds    = "broken clouds"
    case few_clouds       = "few clouds"
    case overcast_clouds  = "overcast clouds"
    case light_rain       = "light rain"
    case Clear            = "Clear"
    case Clouds           = "Clouds"
    case Rain             = "Rain"
    case Snow             = "Snow"

    var description: String{
      switch self {
      case .clear_sky:        return "萬里無雲"
      case .scattered_clouds: return "疏雲"
      case .broken_clouds:    return "裂雲"
      case .few_clouds:       return "少雲"
      case .overcast_clouds:  return "烏雲密佈"
      case .light_rain:       return "下點小雨"
      case .Clear:            return "晴天"
      case .Clouds:           return "陰天"
      case .Rain:             return "雨天"
      case .Snow:             return "下雪天"
      }
    }
  }

  init(description: String){
    guard let describe_type = describeType(rawValue: description) else {
      describeText = ""
      return
    }
    describeText = describe_type.description
  }
  
}
