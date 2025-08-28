//
//  StatsHeader.swift
//  JapanTemperatureMobileApp_ReSwift
//
//  Created by Dev Tech on 2025/08/27.
//

import SwiftUI


struct StatsHeader: View {
let stats: Stats
let lastUpdated: Date?
var body: some View {
VStack(alignment: .leading, spacing: 8) {
HStack(spacing: 16) {
Text("平均 \(stats.average)℃")
Text("最高 \(stats.max)℃")
Text("最低 \(stats.min)℃")
Text("猛暑地域 \(stats.hotRegions)")
}
if let t = lastUpdated {
Text("最終更新: \(t.formatted(date: .omitted, time: .standard))")
.font(.caption)
.foregroundStyle(.secondary)
}
}
.frame(maxWidth: .infinity, alignment: .leading)
}
}


#if DEBUG
struct StatsHeader_Previews: PreviewProvider {
static var previews: some View {
StatsHeader(stats: .init(average: 30, max: 36, min: 22, hotRegions: 3), lastUpdated: .now)
.padding()
.previewLayout(.sizeThatFits)
}
}
#endif
