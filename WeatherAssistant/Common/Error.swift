//
//  Error.swift
//  WeatherAssistant
//
//  Created by michael on 2018/4/6.
//  Copyright © 2018年 michael. All rights reserved.
//

import Foundation

struct SWError {
  enum Code: Int{
    case urlError                = -6000
    case networkRequestFailed    = -6001
    case jsonSerializationFailed = -6002
    case jsonParsingFailed       = -6003
  }

  let errorCode :Code
}
