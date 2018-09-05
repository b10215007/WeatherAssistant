//
//  Observable.swift
//  WeatherAssistant
//
//  Created by michael on 2018/4/6.
//  Copyright © 2018年 michael. All rights reserved.
//

import Foundation

class Observable<T> {
  typealias Observer = (T) -> Void
  var observer : Observer?

  func observe(_ observer: Observer?){
    self.observer = observer
    observer?(value)
  }

  var value: T{
    didSet{
      observer?(value)
    }
  }

  init(_ value : T){
    self.value = value
  }

}
