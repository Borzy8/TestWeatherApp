//
//  Forecast.swift
//  TestWeatherApp
//
//  Created by Borzy on 13.09.18.
//  Copyright © 2018 Borzy. All rights reserved.
//

import UIKit

enum MonthString: String {
    case Sep = "Sep"
    case Oct = "Oct"
    case Nov = "Nov"
    case Dec = "Dec"
    case Jan = "Jan"
    case Feb = "Feb"
    case Mar = "Mar"
    case Apr = "Apr"
    case May = "May"
    case Jun = "Jun"
    case Jul = "Jul"
    case Aug = "Aug"
    
    init(numMonth: Int) {
        switch numMonth {
            case 01: self = .Jan
            case 02: self = .Feb
            case 03: self = .Mar
            case 04: self = .Apr
            case 05: self = .May
            case 06: self = .Jun
            case 07: self = .Jul
            case 08: self = .Aug
            case 09: self = .Sep
            case 10: self = .Oct
            case 11: self = .Nov
            case 12: self = .Dec
        default: self = .Apr
        }
    }
}

enum WeatherIcon: String {
    case ClearSky = "clear-sky"
    case FewClouds = "few-clouds"
    case ScatteredClouds = "scattered-clouds"
    case ShowerRain = "shower-rain"
    case Rain = "rain"
    case Thunderstorm = "thunderstorm"
    case Snow = "snow"
    case Mist = "mist"
    case UnpredictedIcon
    
    init(iconName: String) {
        switch iconName {
            case "01d", "01n": self = .ClearSky
            case "02d", "02n": self = .FewClouds
            case "03n", "03d", "04n", "04d" : self = .ScatteredClouds
            case "09n", "09d": self = .ShowerRain
            case "10d", "10n": self = .Rain
            case "11n", "11d": self = .Thunderstorm
            case "13n", "13d": self = .Snow
            case "50n", "50d": self = .Mist
        default:
            self = .UnpredictedIcon
        }
    }
}

class Forecast {
    var temperature: String?
    var humidity: String?
    var pressure: String?
    var date: String?
    var icon: UIImage?
}
