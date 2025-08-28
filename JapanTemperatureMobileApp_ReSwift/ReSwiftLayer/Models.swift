//
//  Models.swift
//  JapanTemperatureMobileApp_ReSwift
//
//  Created by Dev Tech on 2025/08/27.
//

import Foundation


public enum SortMode: Equatable { case byTempDesc, byGeography }


public struct Region: Identifiable, Equatable {
public let id: UUID
public var name: String
public var currentTemp: Int
public var comments: [String]
public var currentComment: String
public init(id: UUID = UUID(), name: String, currentTemp: Int, comments: [String], currentComment: String) {
self.id = id
self.name = name
self.currentTemp = currentTemp
self.comments = comments
self.currentComment = currentComment
}
}


public struct Stats: Equatable {
public var average: Int
public var max: Int
public var min: Int
public var hotRegions: Int // >= 36℃
}


public let northToSouthOrder: [String] = [
"北海道", "東北", "関東", "中部", "関西", "中国", "四国", "九州", "沖縄"
]


public func computeStats(for regions: [Region]) -> Stats {
guard !regions.isEmpty else { return .init(average: 0, max: 0, min: 0, hotRegions: 0) }
let temps = regions.map { $0.currentTemp }
let avg = Int((Double(temps.reduce(0, +)) / Double(temps.count)).rounded())
return .init(
average: avg,
max: temps.max() ?? 0,
min: temps.min() ?? 0,
hotRegions: temps.filter { $0 >= 36 }.count
)
}


public func defaultRegions() -> [Region] {
[
("北海道", 18...26, ["爽やかな風","朝晩は上着があると安心"]),
("東北", 24...29, ["過ごしやすい陽気","日中は汗ばむことも"]),
("関東", 30...34, ["蒸し暑い","こまめな水分補給を"]),
("中部", 28...32, ["暑さ対策を","日差しが強い"]),
("関西", 31...35, ["厳しい暑さ","屋内でも熱中症注意"]),
("中国", 29...33, ["暑い一日","涼しい室内で休憩を"]),
("四国", 30...34, ["真夏日","冷たい飲み物を用意"]),
("九州", 32...36, ["猛暑日目前","外出は計画的に"]),
("沖縄", 34...38, ["非常に暑い","屋外活動は短時間で"]),
].map { (name, range, comments) in
let temp = Int.random(in: range)
return Region(name: name, currentTemp: temp, comments: comments, currentComment: comments.randomElement() ?? "")
}
}
