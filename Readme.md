# 日本気温モバイルアプリ (ReSwift 版)

日本全国の気温情報を表示・管理する iOS アプリです。ReSwift アーキテクチャを使用してステート管理を行っています。

## 📱 対応 OS

- **iOS 18.5 以上**

## ✨ 機能

### 主要機能

- **気温データ表示**: 日本の 9 地域（北海道、東北、関東、中部、関西、中国、四国、九州、沖縄）の現在気温を表示
- **統計情報**: 平均気温、最高気温、最低気温、猛暑地域数（36℃ 以上）を自動計算して表示
- **リアルタイム更新**: 「気温更新」ボタンで各地域の気温をランダムに更新
- **地域詳細表示**: 地域をタップすると詳細情報とコメントを表示

### ソート機能

- **温度順**: 気温の高い順に地域を並べ替え
- **地域順**: 北から南へ地理的順序で並べ替え

## 🏗️ アーキテクチャ

### ReSwift パターン

このアプリは ReSwift ライブラリを使用した単方向データフローアーキテクチャで構築されています：

- **State**: アプリ全体の状態を`AppState`で管理
- **Actions**: ユーザー操作を`AppAction`で定義
- **Reducers**: アクションに基づいて状態を更新
- **Middleware**: 非同期処理やロギングを実装

### プロジェクト構成

```
JapanTemperatureMobileApp_ReSwift/
├── App/
│   └── JapanTemperatureMobileApp_ReSwift.swift    # メインアプリファイル
├── ReSwiftLayer/
│   ├── Actions.swift           # アクション定義
│   ├── AppState.swift         # アプリケーションステート
│   ├── Models.swift           # データモデル
│   ├── Reducers.swift         # リデューサー
│   ├── Store.swift            # ストア設定
│   └── Middleware.swift       # ミドルウェア
└── Views/
    ├── ContentView_ReSwift.swift   # メインビュー
    ├── StatsHeader.swift          # 統計情報ヘッダー
    ├── ControlsBar.swift          # 操作ボタン
    ├── RegionListView.swift       # 地域リスト
    ├── RegionRow.swift            # 地域行表示
    └── RegionDetail.swift         # 地域詳細表示
```

## 🔧 技術仕様

### 依存関係

- **ReSwift 6.1.1**: ステート管理ライブラリ
- **SwiftUI**: UI フレームワーク
- **Combine**: リアクティブプログラミング

### 主要コンポーネント

#### AppState

```swift
public struct AppState: Equatable {
    public var regions: [Region] = []
    public var selectedRegionID: UUID? = nil
    public var sortMode: SortMode = .byTempDesc
    public var lastUpdated: Date? = nil
    public var stats: Stats = .init(average: 0, max: 0, min: 0, hotRegions: 0)
}
```

#### アクション

- `refreshTapped`: 気温データを更新
- `sortByTemperature`: 温度順でソート
- `sortByGeography`: 地域順でソート
- `selectRegion`: 地域を選択
- `setRegions`: 地域データを設定

## 🚀 セットアップ

### 必要な環境

- Xcode 16.4 以上
- iOS 18.5 以上のシミュレーター/デバイス

### インストール手順

1. **プロジェクトをクローン**

   ```bash
   git clone [リポジトリURL]
   cd JapanTemperatureMobileApp_ReSwift
   ```

2. **Xcode で開く**

   ```bash
   open JapanTemperatureMobileApp_ReSwift.xcodeproj
   ```

3. **依存関係の解決**

   - Xcode が Swift Package Manager 経由で ReSwift を自動的に取得します

4. **ビルド & 実行**
   - シミュレーターまたは実機を選択
   - ⌘+R でビルド・実行

## 📊 データフロー

```
ユーザーアクション → Action → Middleware → Reducer → State → UI更新
```

1. ユーザーがボタンをタップ
2. 対応する Action が発火
3. Middleware で副作用処理（気温のランダム生成など）
4. Reducer が新しい State を計算
5. ObservableStore が UI 更新を通知

## 🎯 主な機能詳細

### 気温更新システム

- 各地域に設定された温度範囲内でランダムに気温を生成
- 地域特性を考慮した現実的な温度範囲
- 更新時刻を自動記録

### 統計計算

- リアルタイムで平均、最高、最低気温を算出
- 36℃ 以上の猛暑地域数をカウント

### ソート機能

- **温度順**: 降順で高温地域から表示
- **地域順**: 北海道から沖縄まで地理的順序

## 🏷️ ライセンス

MIT License - 詳細は[LICENSE](LICENSE)ファイルを参照してください。
