//
//  WeatherViewModel.swift
//  WeatherAssistant
//
//  Created by michael on 2018/4/6.
//  Copyright © 2018年 michael. All rights reserved.
//

import Foundation
import CoreLocation

class WeatherViewModel{
  // MARK: - Constants
  fileprivate let emptyString = ""

  // MARK: - Properties
  let hasError: Observable<Bool>
  let errorMessage: Observable<String?>

  let location: Observable<String>
  let iconText: Observable<String>
  let temperature: Observable<String>
  let temperature_Double: Observable<Double>
  let description: Observable<String>
  let mainWeather: Observable<String>
  let forecasts: Observable<[ForecastViewModel]>
  let forecast4Days: Observable<[Forecast4DaysViewModel]>

  // MARK: - Services
  fileprivate var locationService: LocationService
  fileprivate var weatherService: WeatherServiceProtocol

  // MARK: - init
  init(){
    hasError = Observable(false)
    errorMessage = Observable(nil)

    location = Observable(emptyString)
    iconText = Observable(emptyString)
    temperature = Observable(emptyString)
    temperature_Double = Observable(0)
    description = Observable(emptyString)
    mainWeather = Observable(emptyString)
    forecasts = Observable([])
    forecast4Days = Observable([])

    //Can put Dependency Injection here
    locationService = LocationService()
    weatherService = OpenWeatherMapService()
  }

  // MARK: - public
  func startLocationService(){
    locationService.delegate = self
    locationService.requestLocation()
  }

  // MARK: - private
  fileprivate func update(_ weather: Weather){
    hasError.value = false
    errorMessage.value = nil

    location.value = weather.location
    iconText.value = weather.iconText
    temperature.value = weather.temperature
    temperature_Double.value = weather.temperature_Double
    description.value = weather.description
    mainWeather.value = weather.mainWeather

    let tempForecasts = weather.forecast.map { forecast in
      return ForecastViewModel(forecast)
    }
    let tempForecast4Days = weather.forecast4Days.map { forecast in
      return Forecast4DaysViewModel(forecast)
    }

    forecasts.value = tempForecasts
    forecast4Days.value = tempForecast4Days
  }

  fileprivate func update(_ error: SWError) {
    hasError.value = true

    switch error.errorCode {
    case .urlError:
      errorMessage.value = "The weather service is not working."
    case .networkRequestFailed:
      errorMessage.value = "The network appears to be down."
    case .jsonSerializationFailed:
      errorMessage.value = "We're having trouble processing weather data."
    case .jsonParsingFailed:
      errorMessage.value = "We're having trouble parsing weather data."
    }

    location.value = emptyString
    iconText.value = emptyString
    temperature.value = emptyString
    description.value = emptyString
    mainWeather.value = emptyString
    self.forecasts.value = []
    self.forecast4Days.value = []
  }
}

// MARK: LocationServiceDelegate
extension WeatherViewModel: LocationServiceDelegate {
  func locationDidUpdate(_ service: LocationService, location: CLLocation) {
    weatherService.retrieveWeatherInfo(location) { (weather, error) -> Void in
      DispatchQueue.main.async(execute: {
        if let unwrappedError = error {
          print(unwrappedError)
          self.update(unwrappedError)
          return
        }

        guard let unwrappedWeather = weather else {
          return
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadView"), object: nil)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "setUpData"), object: nil)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "setUpDrData"), object: nil)
        self.update(unwrappedWeather)
      })
    }
  }
}

