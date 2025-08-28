//
//  ContentView_ReSwift.swift
//  JapanTemperatureMobileApp_ReSwift
//
//  Created by Dev Tech on 2025/08/27.
//

import SwiftUI


struct ContentView_ReSwift: View {
@EnvironmentObject var store: ObservableStore


var body: some View {
NavigationView {
VStack(spacing: 12) {
StatsHeader(stats: store.state.stats, lastUpdated: store.state.lastUpdated)
ControlsBar()
RegionListView()
if let selected = store.state.regions.first(where: { $0.id == store.state.selectedRegionID }) {
RegionDetail(region: selected)
}
}
.padding()
.navigationTitle("日本の気温")
}
}
}


#if DEBUG
struct ContentView_ReSwift_Previews: PreviewProvider {
static var previews: some View {
ContentView_ReSwift().environmentObject(ObservableStore(store: mainStore))
}
}
#endif
