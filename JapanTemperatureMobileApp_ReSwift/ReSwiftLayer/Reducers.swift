//
//  Reducers.swift
//  JapanTemperatureMobileApp_ReSwift
//
//  Created by Dev Tech on 2025/08/27.
//

import ReSwift


public func appReducer(action: Action, state: AppState?) -> AppState {
var state = state ?? AppState()
guard let action = action as? AppAction else { return state }


switch action {
case .setRegions(let newRegions, let updatedAt):
state.regions = sort(regions: newRegions, by: state.sortMode)
state.lastUpdated = updatedAt
state.stats = computeStats(for: state.regions)


case .sortByTemperature:
state.sortMode = .byTempDesc
state.regions = sort(regions: state.regions, by: state.sortMode)


case .sortByGeography:
state.sortMode = .byGeography
state.regions = sort(regions: state.regions, by: state.sortMode)


case .selectRegion(let id):
state.selectedRegionID = id


case .refreshTapped:
break
}
return state
}


private func sort(regions: [Region], by mode: SortMode) -> [Region] {
switch mode {
case .byTempDesc:
return regions.sorted { $0.currentTemp > $1.currentTemp }
case .byGeography:
return regions.sorted { a, b in
guard let ia = northToSouthOrder.firstIndex(of: a.name),
let ib = northToSouthOrder.firstIndex(of: b.name) else { return a.name < b.name }
return ia < ib
}
}
}
