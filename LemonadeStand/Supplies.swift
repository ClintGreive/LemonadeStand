//
//  Supplies.swift
//  LemonadeStand
//
//  Created by Clint Greive on 21/12/2014.
//  Copyright (c) 2014 Clint Greive. All rights reserved.
//

import Foundation

struct Supplies {
    var money = 0
    var lemons = 0
    var iceCubes = 0
    
    init (aMoney: Int, aLemons: Int, aIceCubes: Int) {
        money = aMoney
        lemons = aLemons
        iceCubes = aIceCubes
    }
}