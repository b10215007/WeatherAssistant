//
//  ForecastDateTime.swift
//  WeatherAssistant
//
//  Created by michael on 2018/4/6.
//  Copyright © 2018年 michael. All rights reserved.
//

import Foundation

struct ForecastDateTime {
  let rawData : Double

  init(_ data: Double){
    rawData = data
  }

  var showTime: String{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    let date = Date(timeIntervalSince1970: rawData)
    return dateFormatter.string(from: date)
  }

}
