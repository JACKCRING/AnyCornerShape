// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

/// 一个矩形 Shape，四个角的圆角半径都可以独立指定。
///
/// 既可以当作 `Shape` 直接使用，也可以通过
/// ``SwiftUICore/View/anyCornerShape(topLeading:topTrailing:bottomLeading:bottomTrailing:style:)``
/// 修饰符把任意视图裁切成自定义圆角。
///
/// ```swift
/// // 当作 Shape 使用
/// AnyCornerShape(topLeading: 24, topTrailing: 20,
///                bottomLeading: 12, bottomTrailing: 0)
///     .fill(.blue)
///     .frame(width: 200, height: 100)
///
/// // 当作修饰符使用
/// Rectangle()
///     .fill(.blue)
///     .frame(width: 200, height: 100)
///     .anyCornerShape(topLeading: 24, topTrailing: 20,
///                     bottomLeading: 12, bottomTrailing: 0)
/// ```
///
/// 命名说明：参数名借鉴 SwiftUI 的 `UnevenRoundedRectangle`，
/// 但当前实现把它们当作 **物理位置** 处理
/// （`topLeading == 左上`、`topTrailing == 右上`、
/// `bottomLeading == 左下`、`bottomTrailing == 右下`）。
/// 在 RTL 场景下如需镜像，请自行交换 leading 与 trailing。
///
/// 圆角风格：`style` 参数在 iOS 16 / macOS 13 / tvOS 16 / watchOS 9 /
/// visionOS 1 及以上版本会被忠实保留（`.continuous` 走系统的 squircle）；
/// 在更老的系统上会自动降级为 `.circular`（标准圆弧）。
public struct AnyCornerShape: InsettableShape, Sendable {

    /// 左上角圆角半径。
    public var topLeading: CGFloat
    /// 右上角圆角半径。
    public var topTrailing: CGFloat
    /// 左下角圆角半径。
    public var bottomLeading: CGFloat
    /// 右下角圆角半径。
    public var bottomTrailing: CGFloat

    /// 圆角风格。`.continuous` 仅在 iOS 16+/macOS 13+/tvOS 16+/watchOS 9+/visionOS 1+
    /// 上生效，更老的系统会自动按 `.circular` 渲染。
    public var style: RoundedCornerStyle

    /// 由 `inset(by:)` 累积，用于支持 `strokeBorder` 等内缩绘制。
    private var insetAmount: CGFloat = 0

    /// 创建一个可独立配置四个圆角半径的矩形。
    ///
    /// - Parameters:
    ///   - topLeading: 左上角半径，默认 `0`。
    ///   - topTrailing: 右上角半径，默认 `0`。
    ///   - bottomLeading: 左下角半径，默认 `0`。
    ///   - bottomTrailing: 右下角半径，默认 `0`。
    ///   - style: 圆角风格，默认 `.circular`。`.continuous` 仅在新系统生效。
    public init(
        topLeading: CGFloat = 0,
        topTrailing: CGFloat = 0,
        bottomLeading: CGFloat = 0,
        bottomTrailing: CGFloat = 0,
        style: RoundedCornerStyle = .circular
    ) {
        self.topLeading = topLeading
        self.topTrailing = topTrailing
        self.bottomLeading = bottomLeading
        self.bottomTrailing = bottomTrailing
        self.style = style
    }

    /// 四个角使用相同半径的便捷初始化器。
    public init(_ radius: CGFloat, style: RoundedCornerStyle = .circular) {
        self.init(
            topLeading: radius,
            topTrailing: radius,
            bottomLeading: radius,
            bottomTrailing: radius,
            style: style
        )
    }

    public func path(in rect: CGRect) -> Path {
        let r = rect.insetBy(dx: insetAmount, dy: insetAmount)
        guard r.width > 0, r.height > 0 else { return Path() }

        // 1. 内缩后每个角的半径也要相应缩小，并截到 0 以上。
        let rawTL = max(0, topLeading - insetAmount)
        let rawTR = max(0, topTrailing - insetAmount)
        let rawBL = max(0, bottomLeading - insetAmount)
        let rawBR = max(0, bottomTrailing - insetAmount)

        // 2. 单个角不能超过最短边的一半。
        let maxRadius = min(r.width, r.height) / 2
        var tl = min(rawTL, maxRadius)
        var tr = min(rawTR, maxRadius)
        var bl = min(rawBL, maxRadius)
        var br = min(rawBR, maxRadius)

        // 3. 相邻两角之和不能超过对应边长（CSS border-radius 那种等比缩放）。
        let scaleTop    = (tl + tr) > r.width  ? r.width  / (tl + tr) : 1
        let scaleBottom = (bl + br) > r.width  ? r.width  / (bl + br) : 1
        let scaleLeft   = (tl + bl) > r.height ? r.height / (tl + bl) : 1
        let scaleRight  = (tr + br) > r.height ? r.height / (tr + br) : 1
        let scale = min(min(scaleTop, scaleBottom), min(scaleLeft, scaleRight))
        if scale < 1 {
            tl *= scale; tr *= scale; bl *= scale; br *= scale
        }

        // 4a. 新系统：直接转发给原生 UnevenRoundedRectangle，
        //     `.continuous` 才能拿到苹果的 squircle 效果。
        #if compiler(>=5.7)
        if #available(iOS 16, macOS 13, tvOS 16, watchOS 9, visionOS 1, *) {
            let radii = RectangleCornerRadii(
                topLeading: tl,
                bottomLeading: bl,
                bottomTrailing: br,
                topTrailing: tr
            )
            return UnevenRoundedRectangle(cornerRadii: radii, style: style)
                .path(in: r)
        }
        #endif

        // 4b. 老系统降级：手动画圆弧（等价于 `.circular`）。
        return Self.circularPath(in: r, tl: tl, tr: tr, bl: bl, br: br)
    }

    /// 手动绘制四角圆弧的路径，作为不支持 `UnevenRoundedRectangle` 系统的回退实现。
    private static func circularPath(
        in r: CGRect,
        tl: CGFloat, tr: CGFloat,
        bl: CGFloat, br: CGFloat
    ) -> Path {
        var path = Path()
        // 顶边起点：左上圆弧结束的位置
        path.move(to: CGPoint(x: r.minX + tl, y: r.minY))

        // 顶边 -> 右上圆弧
        path.addLine(to: CGPoint(x: r.maxX - tr, y: r.minY))
        if tr > 0 {
            path.addArc(
                center: CGPoint(x: r.maxX - tr, y: r.minY + tr),
                radius: tr,
                startAngle: .degrees(-90),
                endAngle: .degrees(0),
                clockwise: false
            )
        }

        // 右边 -> 右下圆弧
        path.addLine(to: CGPoint(x: r.maxX, y: r.maxY - br))
        if br > 0 {
            path.addArc(
                center: CGPoint(x: r.maxX - br, y: r.maxY - br),
                radius: br,
                startAngle: .degrees(0),
                endAngle: .degrees(90),
                clockwise: false
            )
        }

        // 底边 -> 左下圆弧
        path.addLine(to: CGPoint(x: r.minX + bl, y: r.maxY))
        if bl > 0 {
            path.addArc(
                center: CGPoint(x: r.minX + bl, y: r.maxY - bl),
                radius: bl,
                startAngle: .degrees(90),
                endAngle: .degrees(180),
                clockwise: false
            )
        }

        // 左边 -> 左上圆弧
        path.addLine(to: CGPoint(x: r.minX, y: r.minY + tl))
        if tl > 0 {
            path.addArc(
                center: CGPoint(x: r.minX + tl, y: r.minY + tl),
                radius: tl,
                startAngle: .degrees(180),
                endAngle: .degrees(270),
                clockwise: false
            )
        }

        path.closeSubpath()
        return path
    }

    public func inset(by amount: CGFloat) -> some InsettableShape {
        var copy = self
        copy.insetAmount += amount
        return copy
    }

    /// 让四个圆角支持 SwiftUI 动画插值。
    public var animatableData: AnimatablePair<
        AnimatablePair<CGFloat, CGFloat>,
        AnimatablePair<CGFloat, CGFloat>
    > {
        get {
            AnimatablePair(
                AnimatablePair(topLeading, topTrailing),
                AnimatablePair(bottomLeading, bottomTrailing)
            )
        }
        set {
            topLeading     = newValue.first.first
            topTrailing    = newValue.first.second
            bottomLeading  = newValue.second.first
            bottomTrailing = newValue.second.second
        }
    }
}
