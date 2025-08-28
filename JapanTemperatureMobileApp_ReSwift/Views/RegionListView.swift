//
//  RegionListView.swift
//  JapanTemperatureMobileApp_ReSwift
//
//  Created by Dev Tech on 2025/08/27.
//

import SwiftUI


struct RegionListView: View {
@EnvironmentObject var store: ObservableStore


var body: some View {
List(store.state.regions) { region in
RegionRow(region: region)
.contentShape(Rectangle())
.onTapGesture { store.dispatch(AppAction.selectRegion(region.id)) }
}
.listStyle(.plain)
}
}


#if DEBUG
struct RegionListView_Previews: PreviewProvider {
static var previews: some View {
RegionListView().environmentObject(ObservableStore(store: mainStore))
}
}
#endif
