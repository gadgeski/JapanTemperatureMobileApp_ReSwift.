//
//  Actions.swift
//  JapanTemperatureMobileApp_ReSwift
//
//  Created by Dev Tech on 2025/08/27.
//

import Foundation
import ReSwift


public enum AppAction: Action {
case refreshTapped
case sortByTemperature
case sortByGeography
case selectRegion(UUID?)
case setRegions([Region], updatedAt: Date)
}
