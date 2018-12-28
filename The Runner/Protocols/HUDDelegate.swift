//
//  HUDDelegate.swift
//  The Runner
//
//  Created by Alex Gomez on 12/28/18.
//  Copyright © 2018 Alex Gomez. All rights reserved.
//

import Foundation

protocol HUDDelegate {
    func updateCoinLabel(coins: Int)
    func addSuperCoin(index: Int)
}
