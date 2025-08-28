//
//  Middleware.swift
//  JapanTemperatureMobileApp_ReSwift
//
//  Created by Dev Tech on 2025/08/27.
//
import Foundation
import ReSwift


public func temperatureMiddleware() -> Middleware<AppState> {
{ dispatch, getState in { next in { action in
guard let appAction = action as? AppAction else {
next(action)
return
}
switch appAction {
case .refreshTapped:
let now = Date()
let current = getState()?.regions ?? defaultRegions()
let updated: [Region] = current.map { region in
var region = region
let range: ClosedRange<Int>
switch region.name {
case "北海道": range = 18...26
case "東北": range = 24...29
case "関東": range = 30...34
case "中部": range = 28...32
case "関西": range = 31...35
case "中国": range = 29...33
case "四国": range = 30...34
case "九州": range = 32...36
case "沖縄": range = 34...38
default: range = max(region.currentTemp-2, 0)...(region.currentTemp+2)
}
region.currentTemp = Int.random(in: range)
if let c = region.comments.randomElement() { region.currentComment = c }
return region
}
dispatch(AppAction.setRegions(updated, updatedAt: now))
next(action)
default:
next(action)
}
} } }
}


public func loggingMiddleware() -> Middleware<AppState> {
{ _, _ in { next in { action in
#if DEBUG
print("[Action]", action)
#endif
next(action)
} } }
}
