//
//  RegionDetail.swift
//  JapanTemperatureMobileApp_ReSwift
//
//  Created by Dev Tech on 2025/08/27.
//

import SwiftUI


struct RegionDetail: View {
let region: Region
var body: some View {
VStack(alignment: .leading, spacing: 8) {
Text("\(region.name)の詳細")
.font(.headline)
Text(region.currentComment)
ProgressView(value: Double(min(max(region.currentTemp, 0), 40)), total: 40)
}
.padding()
.frame(maxWidth: .infinity)
.background(.ultraThinMaterial)
.clipShape(RoundedRectangle(cornerRadius: 12))
}
}


#if DEBUG
struct RegionDetail_Previews: PreviewProvider {
static var previews: some View {
RegionDetail(region: Region(name: "沖縄", currentTemp: 35, comments: ["非常に暑い"], currentComment: "非常に暑い"))
.padding()
.previewLayout(.sizeThatFits)
}
}
#endif
