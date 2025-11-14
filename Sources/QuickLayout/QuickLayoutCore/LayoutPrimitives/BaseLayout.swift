/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation
import UIKit

extension Layout {

  public func sizeThatFits(_ proposedSize: CGSize) -> CGSize {
    quick_layoutThatFits(sanitizeSize(proposedSize)).size
  }

  public func layoutThatFits(_ proposedSize: CGSize, layoutDirection: LayoutDirection? = nil) -> LayoutNode {
    let layoutDirection = layoutDirection ?? LayoutContext.layoutDirection
    return LayoutContext.$layoutDirection.withValue(layoutDirection) {
      quick_layoutThatFits(sanitizeSize(proposedSize))
    }
  }

  @MainActor
  public func applyFrame(_ frame: CGRect, alignment: Alignment, layoutDirection: LayoutDirection?) {
    _applyFrame(frame, alignment: alignment, layoutDirection: layoutDirection, cachedLayout: nil)
  }

  @MainActor
  public func _applyFrame(_ frame: CGRect, alignment: Alignment, layoutDirection: LayoutDirection?, cachedLayout: LayoutNode?) {
    let layoutDirection = layoutDirection ?? LayoutContext.layoutDirection
    LayoutContext.$layoutDirection.withValue(layoutDirection) {
      let sanitizedFrame = sanitizeFrame(frame)
      let dimensions = ElementDimensions(sanitizedFrame.size)
      let layout = cachedLayout ?? quick_layoutThatFits(sanitizedFrame.size)
      let x = sanitizedFrame.size.width.isInfinite ? 0.0 : roundPositionToPixelGrid(dimensions[alignment.horizontal] - layout.dimensions[alignment.horizontal])
      let y = sanitizedFrame.size.height.isInfinite ? 0.0 : roundPositionToPixelGrid(dimensions[alignment.vertical] - layout.dimensions[alignment.vertical])

      commitLayout(
        child: LayoutNode.Child(position: .zero, layout: layout),
        position: CGPoint(x: sanitizedFrame.origin.x + x, y: sanitizedFrame.origin.y + y)
      )
    }
  }

  public func views() -> [UIView] {
    var views: [UIView] = []
    quick_extractViewsIntoArray(&views)
    return views
  }
}

private func sanitizePosition(_ value: CGFloat) -> CGFloat {
  if value.isNaN { return 0.0 }
  return value
}

// Preventing from passing NaN and negative sizes to the layout. Replacing CGFloat.greatestFiniteMagnitude with infinity.
private func sanitizeDimension(_ value: CGFloat) -> CGFloat {
  if value.isNaN { return 0.0 }
  if value == CGFloat.greatestFiniteMagnitude { return .infinity }
  return max(value, 0.0)
}

private func sanitizeSize(_ size: CGSize) -> CGSize {
  CGSize(width: sanitizeDimension(size.width), height: sanitizeDimension(size.height))
}

// Preventing from passing NaNs and negatives to the layout. Though allowing infinite sizes.
private func sanitizeFrame(_ input: CGRect) -> CGRect {
  CGRect(x: sanitizePosition(input.origin.x), y: sanitizePosition(input.origin.y), width: sanitizeDimension(input.width), height: sanitizeDimension(input.height))
}

@MainActor
private func commitLayout(child: LayoutNode.Child, position: CGPoint) {
  let origin = CGPoint(x: position.x + child.position.x, y: position.y + child.position.y)
  if let view = child.layout.view {
    let size = CGSize(width: child.layout.size.width, height: child.layout.size.height)
    set(origin: origin, size: size, for: view)
  }
  child.layout.children.forEach { child in
    commitLayout(child: child, position: origin)
  }
}

/// Not using the "frame" property because changing it resets the transform of the view.
/// The method sets "center" and "bounds" and lets UIKit resolve the frame with the current view transform.
/// See the diff description for more details. D62157627
@MainActor
private func set(origin: CGPoint, size: CGSize, for view: UIView) {
  let anchorPoint = view.layer.anchorPoint
  view.bounds = CGRect(origin: view.bounds.origin, size: size)
  view.center = CGPoint(x: origin.x + size.width * anchorPoint.x, y: origin.y + size.height * anchorPoint.y)
}
