<p align="left">
  <img src="PressKits/Logo.png" alt="AnyCornerShape" width="1024" />
</p>

[English](README.md) · **繁體中文**

一個輕量的 SwiftUI 元件：讓你獨立設定矩形四個角的圓角半徑。

```swift
AnyCornerShape(topLeading: 24, topTrailing: 20, bottomLeading: 12, bottomTrailing: 0)   // 當作 Shape

Rectangle().anyCornerShape(topLeading: 24, bottomTrailing: 16)                           // 當作修飾符
```

[![Swift](https://img.shields.io/badge/Swift-6.0-orange.svg)](https://swift.org)
[![SPM](https://img.shields.io/badge/SwiftPM-compatible-brightgreen.svg)](https://swift.org/package-manager)
![Platforms](https://img.shields.io/badge/Platforms-iOS%2013%20%7C%20macOS%2010.15%20%7C%20tvOS%2013%20%7C%20watchOS%206%20%7C%20visionOS%201-blue.svg)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

---

## 應用場景

適用於任何需要不對稱圓角的介面：卡片、彈出視窗、聊天氣泡、標籤頁、底部彈出面板、頭像裁切等。任何想要對單一角或多角單獨控制圓角的 SwiftUI 視圖，都可以使用本元件。

## 特性

- 四個角的圓角半徑都可以獨立指定。
- 兩種約束模式：**嚴格**（預設，永遠安全對稱）與**寬松**（允許單邊大圓角，做出葉子形 / D 形）。
- 同時支援 `Shape` 與 `View` 修飾符兩種用法，寫法與 SwiftUI 原生形狀風格一致。
- 支援 `RoundedCornerStyle`（`.continuous` squircle / `.circular`），並在舊系統自動降級為 `.circular`。
- 遵循 `InsettableShape`，`strokeBorder` 等內縮繪製開箱即用。
- 支援 SwiftUI 動畫插值（`animatableData`）。
- 自動進行圓角等比縮放（CSS `border-radius` 風格），半徑永不超出邊長，形狀不會破裂。
- 提供四角相同半徑的便捷初始化器 / 修飾符。
- 純 Swift，零三方依賴；支援 Swift 6 嚴格並發。
- 全平台支援：iOS、macOS、tvOS、watchOS、visionOS。

## 安裝

### Swift Package Manager

在 Xcode 裡 `File > Add Packages…`，貼上倉庫地址即可。

或在 `Package.swift` 中：

```swift
dependencies: [
    .package(url: "https://github.com/jackcring/AnyCornerShape.git", from: "1.0.0")
],
targets: [
    .target(
        name: "YourApp",
        dependencies: ["AnyCornerShape"]
    )
]
```

最低部署版本：

| Platform | Min   |
| -------- | ----- |
| iOS      | 13.0  |
| macOS    | 10.15 |
| tvOS     | 13.0  |
| watchOS  | 6.0   |
| visionOS | 1.0   |

## 快速開始

```swift
import AnyCornerShape
import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Hello")
            .padding()
            .background(.blue)
            .foregroundStyle(.white)
            .anyCornerShape(topLeading: 16, bottomTrailing: 16)
    }
}
```

四個角使用相同半徑時，可以用更簡潔的寫法：

```swift
Rectangle()
    .fill(.green)
    .frame(width: 120, height: 120)
    .anyCornerShape(20)
```

需要填色或描邊時，直接當作 `Shape` 使用：

```swift
AnyCornerShape(topLeading: 24, topTrailing: 20, bottomLeading: 12, bottomTrailing: 0)
    .fill(.blue)
    .frame(width: 200, height: 100)
```

## 約束模式

用 `clamp` 參數控制半徑過大時的處理方式，預設 `.strict`，`Shape` 初始化器與兩個修飾符都支援。

- `.strict`（預設）：單角上限為 `min(寬, 高) / 2`。同一條邊上相邻兩角之和超過邊長時，四個角一起按比例縮小。形狀永遠安全、對稱、不自相交。
- `.relaxed`：單角上限放寬到 `min(寬, 高)`（單個角真正的幾何極限），可以做出單邊大圓角，例如葉子形或「D」形。相邻兩角衝突時只對涉及的那條邊做局部縮放，盡量保留大圓角的意圖。

```swift
// 嚴格（預設）：在 200 x 100 的矩形上，單角最大 50
Rectangle().anyCornerShape(topLeading: 80)

// 寬松：同一個角可以到 100
Rectangle().anyCornerShape(topLeading: 80, clamp: .relaxed)

// 當作 Shape
AnyCornerShape(topLeading: 100, style: .continuous, clamp: .relaxed)
    .fill(.blue)
    .frame(width: 200, height: 100)
```

## 常見問題

**Q：`.continuous` 風格沒有效果？**

A：`.continuous`（squircle）僅在 iOS 16+ / macOS 13+ / tvOS 16+ / watchOS 9+ / visionOS 1+ 生效，更舊的系統會自動降級為 `.circular` 標準圓弧。

**Q：RTL（由右至左）佈局下圓角位置不對？**

A：參數按物理位置處理（`topLeading` 為左上角）。如需在 RTL 場景鏡像，請自行交換 leading 與 trailing 的數值。

**Q：設定的半徑太大會怎樣？**

A：`.strict` 模式下會把每個半徑截到最短邊的一半，並對相鄰角做等比縮放，形狀不會破裂；`.relaxed` 模式則把單角上限放寬到最短邊長度，以支援單邊大圓角。詳見[約束模式](#約束模式)。

**Q：可以畫出四角獨立的邊框嗎？**

A：可以。`AnyCornerShape` 遵循 `InsettableShape`，`strokeBorder` 能正常運作並對齊內縮邊緣。

## 貢獻

歡迎 PR、issue。修改前請先跑一遍：

```bash
swift build
swift test
```

## License

MIT License，詳見 [LICENSE](LICENSE)。

## Author

**Jc** © [jackcirng.com](https://jackcirng.com)
