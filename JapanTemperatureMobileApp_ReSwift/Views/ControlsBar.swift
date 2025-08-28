//
//  ControlsBar.swift
//  JapanTemperatureMobileApp_ReSwift
//
//  Created by Dev Tech on 2025/08/27.
//

import SwiftUI


struct ControlsBar: View {
@EnvironmentObject var store: ObservableStore
var body: some View {
HStack(spacing: 8) {
Button("気温更新") { store.dispatch(AppAction.refreshTapped) }
.buttonStyle(.borderedProminent)
Button("温度順") { store.dispatch(AppAction.sortByTemperature) }
.buttonStyle(.bordered)
Button("地域順") { store.dispatch(AppAction.sortByGeography) }
.buttonStyle(.bordered)
}
}
}


#if DEBUG
struct ControlsBar_Previews: PreviewProvider {
static var previews: some View {
ControlsBar().environmentObject(ObservableStore(store: mainStore))
.padding()
.previewLayout(.sizeThatFits)
}
}
#endif
