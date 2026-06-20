<p align="center">
  <img src="./Logo.png" alt="AnyCornerShape Logo" width="200" />
</p>

<p align="center">
  <a href="#anycornershape-english"><b>English</b></a> · <a href="#anycornershape-繁體中文">繁體中文</a>
</p>

---

# AnyCornerShape (English)

`AnyCornerShape` is a lightweight SwiftUI component that lets you **set the corner radius of each of a rectangle's four corners independently**. Use it directly as a `Shape`, or apply the `.anyCornerShape(...)` modifier to clip any view into a custom rounded shape.

```swift
import SwiftUI
import AnyCornerShape

// Use as a Shape
AnyCornerShape(topLeading: 24, topTrailing: 20,
               bottomLeading: 12, bottomTrailing: 0)
    .fill(.blue)
    .frame(width: 200, height: 100)

// Use as a modifier
Rectangle()
    .fill(.blue)
    .frame(width: 200, height: 100)
    .anyCornerShape(topLeading: 24, topTrailing: 20,
                    bottomLeading: 12, bottomTrailing: 0)
```

![Swift](https://img.shields.io/badge/Swift-6.0-orange.svg)
![SPM](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)
![Platforms](https://img.shields.io/badge/Platforms-iOS%20%7C%20macOS%20%7C%20tvOS%20%7C%20watchOS%20%7C%20visionOS-blue.svg)
![License](https://img.shields.io/badge/License-MIT-lightgrey.svg)

---

## Use Cases

Suitable for any UI that needs asymmetric corners: cards, popovers, chat bubbles, tabs, bottom sheets, avatar clipping, and more. Any SwiftUI view that needs per-corner radius control can use this component.

## Features

- Each of the four corners has an independent radius
- Works both as a `Shape` and as a `View` modifier
- Supports `RoundedCornerStyle` (`.continuous` squircle / `.circular`) with automatic fallback on older systems
- Conforms to `InsettableShape`, supporting `strokeBorder` and inset drawing
- Supports SwiftUI animation interpolation (`animatableData`)
- Automatic proportional radius scaling to avoid radii exceeding edge lengths
- Cross-platform: iOS, macOS, tvOS, watchOS, visionOS

## Installation

Install via Swift Package Manager. In Xcode choose `File > Add Package Dependencies` and enter the repository URL, or add it to `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/jackcring/AnyCornerShape.git", from: "1.0.0")
]
```

Minimum supported platforms:

| Platform | Minimum Version |
| -------- | --------------- |
| iOS      | 13.0            |
| macOS    | 10.15           |
| tvOS     | 13.0            |
| watchOS  | 6.0             |
| visionOS | 1.0             |

## Quick Start

```swift
import SwiftUI
import AnyCornerShape

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

When all four corners share the same radius, use the shorthand:

```swift
Rectangle()
    .fill(.green)
    .frame(width: 120, height: 120)
    .anyCornerShape(20)
```

## FAQ

**Q: The `.continuous` style has no effect.**
A: `.continuous` (squircle) only applies on iOS 16+ / macOS 13+ / tvOS 16+ / watchOS 9+ / visionOS 1+. Older systems automatically fall back to the `.circular` standard arc.

**Q: Corner positions look wrong in RTL layouts.**
A: Parameters are currently treated as **physical positions** (`topLeading` is the top-left corner). To mirror in RTL, swap the leading and trailing values yourself.

**Q: What happens if a radius is too large?**
A: The component clamps each radius to half of the shortest edge and proportionally scales adjacent corners, so the shape never breaks.

## Contributing

Issues and pull requests are welcome. Before submitting, please build and verify:

```bash
swift build
swift test
```

Keep code style consistent, write clear commit messages, and document new features.

## License

Released under the **MIT License**. You are free to use, modify, and distribute it, provided the original copyright and license notice are retained. See the `LICENSE` file for details.

---

# AnyCornerShape (繁體中文)

`AnyCornerShape` 是一個輕量的 SwiftUI 元件，讓你能夠**獨立設定矩形四個角的圓角半徑**。它既可以直接當作 `Shape` 使用，也可以透過 `.anyCornerShape(...)` 修飾符把任意視圖裁切成自訂圓角。

```swift
import SwiftUI
import AnyCornerShape

// 當作 Shape 使用
AnyCornerShape(topLeading: 24, topTrailing: 20,
               bottomLeading: 12, bottomTrailing: 0)
    .fill(.blue)
    .frame(width: 200, height: 100)

// 當作修飾符使用
Rectangle()
    .fill(.blue)
    .frame(width: 200, height: 100)
    .anyCornerShape(topLeading: 24, topTrailing: 20,
                    bottomLeading: 12, bottomTrailing: 0)
```

![Swift](https://img.shields.io/badge/Swift-6.0-orange.svg)
![SPM](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)
![Platforms](https://img.shields.io/badge/Platforms-iOS%20%7C%20macOS%20%7C%20tvOS%20%7C%20watchOS%20%7C%20visionOS-blue.svg)
![License](https://img.shields.io/badge/License-MIT-lightgrey.svg)

---

## 應用場景

適用於任何需要不對稱圓角的介面：卡片、彈出視窗、聊天氣泡、標籤頁、底部彈出面板、頭像裁切等。任何想要對單一角或多角單獨控制圓角的 SwiftUI 視圖，都可以使用本元件。

## 核心特性

- 四個角的圓角半徑都可以獨立指定
- 同時支援 `Shape` 與 `View` 修飾符兩種用法
- 支援 `RoundedCornerStyle`（`.continuous` squircle / `.circular`），並在舊系統自動降級
- 遵循 `InsettableShape`，支援 `strokeBorder` 等內縮繪製
- 支援 SwiftUI 動畫插值（`animatableData`）
- 自動進行圓角等比縮放，避免半徑超出邊長
- 全平台支援：iOS、macOS、tvOS、watchOS、visionOS

## 安裝教程

透過 Swift Package Manager 安裝。在 Xcode 中選擇 `File > Add Package Dependencies`，輸入倉庫網址即可；或在 `Package.swift` 中加入：

```swift
dependencies: [
    .package(url: "https://github.com/jackcring/AnyCornerShape.git", from: "1.0.0")
]
```

最低適配平台：

| 平台     | 最低版本 |
| -------- | -------- |
| iOS      | 13.0     |
| macOS    | 10.15    |
| tvOS     | 13.0     |
| watchOS  | 6.0      |
| visionOS | 1.0      |

## 零配置快速上手

```swift
import SwiftUI
import AnyCornerShape

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

## 常見問題 Q&A

**Q：`.continuous` 風格沒有效果？**
A：`.continuous`（squircle）僅在 iOS 16+ / macOS 13+ / tvOS 16+ / watchOS 9+ / visionOS 1+ 生效，更舊的系統會自動降級為 `.circular` 標準圓弧。

**Q：RTL（由右至左）佈局下圓角位置不對？**
A：目前參數按**物理位置**處理（`topLeading` 為左上角）。如需在 RTL 場景鏡像，請自行交換 leading 與 trailing 的數值。

**Q：設定的半徑太大會怎樣？**
A：元件會自動把半徑截到最短邊的一半，並對相鄰兩角做等比縮放，確保形狀不會破裂。

## 開源貢獻指南

歡迎提交 Issue 與 Pull Request。提交前請先建置並確認通過：

```bash
swift build
swift test
```

請保持程式碼風格一致、提交訊息清晰，並為新功能補上對應說明。

## 開源協議

本專案基於 **MIT License** 開源，你可以自由地使用、修改與散佈，惟須保留原始版權與授權聲明。詳見 `LICENSE` 檔案。

---

## Author

**Jc** © [jackcirng.com](https://jackcirng.com)
