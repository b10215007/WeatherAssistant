//
//  Forecast4DaysViewModel.swift
//  WeatherAssistant
//
//  Created by michael on 2018/4/9.
//  Copyright © 2018年 michael. All rights reserved.
//

import Foundation


struct Forecast4DaysViewModel {
  let time:        Observable<String>
  let temperature: Observable<String>
  let temperature_Double :Observable<Double>
  let mainWeather: Observable<String>

  init(_ forecast: Forecast){
    time = Observable(forecast.time)
    temperature = Observable(forecast.temperature)
    mainWeather = Observable(forecast.mainWeather)
    temperature_Double = Observable(forecast.temperature_Double)
  }
}
