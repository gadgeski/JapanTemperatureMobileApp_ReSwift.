//
//  Store.swift
//  JapanTemperatureMobileApp_ReSwift
//
//  Created by Dev Tech on 2025/08/27.
//
import Foundation
import ReSwift
import Combine


public let mainStore: Store<AppState> = {
let initial = defaultRegions()
let initialState: AppState = {
var s = AppState()
s.regions = initial
s.stats = computeStats(for: initial)
s.lastUpdated = Date()
return s
}()
return Store<AppState>(
reducer: appReducer,
state: initialState,
middleware: [temperatureMiddleware(), loggingMiddleware()]
)
}()


public final class ObservableStore: ObservableObject, StoreSubscriber {
public typealias StoreSubscriberStateType = AppState
@Published public private(set) var state: AppState
private let store: Store<AppState>


public init(store: Store<AppState> = mainStore) {
self.store = store
self.state = store.state
store.subscribe(self)
}
deinit { store.unsubscribe(self) }


public func newState(state: AppState) {
DispatchQueue.main.async { [weak self] in self?.state = state }
}


public func dispatch(_ action: Action) { store.dispatch(action) }
}
