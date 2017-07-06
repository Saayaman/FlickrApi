//
//  OvenState.swift
//  FlickerApi
//
//  Created by ayako_sayama on 2017-07-04.
//  Copyright © 2017 ayako_sayama. All rights reserved.
//

import UIKit

enum OvenState{
    case on(Double)
    case off
}

var ovenState = OvenState.on(450)

switch ovenState{
case let .on(temperature):
    print("The oven is on and se tto \(temperature) degrees")
case .off:
    print("The oven is off")
}
