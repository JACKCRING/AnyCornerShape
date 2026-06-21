import SwiftUI

public extension View {

    /// 用一个四角可独立设置半径的圆角矩形裁切当前视图。
    ///
    /// ```swift
    /// Rectangle()
    ///     .fill(.blue)
    ///     .frame(width: 200, height: 100)
    ///     .anyCornerShape(topLeading: 24,
    ///                     topTrailing: 20,
    ///                     bottomLeading: 12,
    ///                     bottomTrailing: 0)
    /// ```
    ///
    /// - Parameters:
    ///   - topLeading: 左上角半径，默认 `0`。
    ///   - topTrailing: 右上角半径，默认 `0`。
    ///   - bottomLeading: 左下角半径，默认 `0`。
    ///   - bottomTrailing: 右下角半径，默认 `0`。
    ///   - style: 圆角风格，默认 `.circular`。
    ///     在 iOS 16+/macOS 13+/tvOS 16+/watchOS 9+/visionOS 1+ 上 `.continuous`
    ///     会使用系统 squircle 渲染；更老系统会降级为标准圆弧。
    ///   - clamp: 半径约束模式，默认 `.strict`。`.relaxed` 允许单边大圆角。
    /// - Returns: 已经按指定圆角裁切过的视图。
    func anyCornerShape(
        topLeading: CGFloat = 0,
        topTrailing: CGFloat = 0,
        bottomLeading: CGFloat = 0,
        bottomTrailing: CGFloat = 0,
        style: RoundedCornerStyle = .circular,
        clamp: CornerClamp = .strict
    ) -> some View {
        clipShape(
            AnyCornerShape(
                topLeading: topLeading,
                topTrailing: topTrailing,
                bottomLeading: bottomLeading,
                bottomTrailing: bottomTrailing,
                style: style,
                clamp: clamp
            )
        )
    }

    /// 四个角使用相同半径的便捷修饰符。
    func anyCornerShape(
        _ radius: CGFloat,
        style: RoundedCornerStyle = .circular,
        clamp: CornerClamp = .strict
    ) -> some View {
        clipShape(AnyCornerShape(radius, style: style, clamp: clamp))
    }
}
