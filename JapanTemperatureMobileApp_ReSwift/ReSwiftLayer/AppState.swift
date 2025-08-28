//
//  AppState.swift
//  JapanTemperatureMobileApp_ReSwift
//
//  Created by Dev Tech on 2025/08/27.
//
import Foundation
import ReSwift


public struct AppState: Equatable {
public var regions: [Region] = []
public var selectedRegionID: UUID? = nil
public var sortMode: SortMode = .byTempDesc
public var lastUpdated: Date? = nil
public var stats: Stats = .init(average: 0, max: 0, min: 0, hotRegions: 0)
}
