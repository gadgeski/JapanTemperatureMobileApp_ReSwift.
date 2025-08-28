//
//  RegionRow.swift
//  JapanTemperatureMobileApp_ReSwift
//
//  Created by Dev Tech on 2025/08/27.
//

import SwiftUI


struct RegionRow: View {
let region: Region
var body: some View {
HStack {
Text(region.name)
Spacer()
Text("\(region.currentTemp)℃")
.fontWeight(.semibold)
}
}
}


#if DEBUG
struct RegionRow_Previews: PreviewProvider {
static var previews: some View {
RegionRow(region: Region(name: "関東", currentTemp: 33, comments: ["蒸し暑い"], currentComment: "蒸し暑い"))
.padding()
.previewLayout(.sizeThatFits)
}
}
#endif
