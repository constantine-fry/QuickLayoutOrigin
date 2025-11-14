/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation
import UIKit

public struct ResizableElement: Layout {

  private let child: LeafElement
  private let resizableAxis: AxisSet

  public init(child: LeafElement, axis: AxisSet) {
    self.child = child
    self.resizableAxis = axis
  }

  public func quick_flexibility(for axis: Axis) -> Flexibility {
    if axis == .horizontal && resizableAxis.contains(.horizontal) {
      return .fullyFlexible
    }
    if axis == .vertical && resizableAxis.contains(.vertical) {
      return .fullyFlexible
    }
    return child.quick_flexibility(for: axis)
  }

  public func quick_layoutPriority() -> CGFloat {
    child.quick_layoutPriority()
  }

  public func quick_layoutThatFits(_ proposedSize: CGSize) -> LayoutNode {
    let isHorizontal = resizableAxis.contains(.horizontal)
    let isVertical = resizableAxis.contains(.vertical)
    if isHorizontal && isVertical && proposedSize.width.isFinite && proposedSize.height.isFinite {
      let size = sanitizeSize(CGSize(width: proposedSize.width, height: proposedSize.height))
      return LayoutNode(view: child.backingView(), dimensions: ElementDimensions(size))
    }

    let childLayout = child.quick_layoutThatFits(proposedSize)
    var childSize = childLayout.size
    if isHorizontal && proposedSize.width.isFinite {
      childSize.width = proposedSize.width
    }
    if isVertical && proposedSize.height.isFinite {
      childSize.height = proposedSize.height
    }
    return LayoutNode(view: childLayout.view, dimensions: ElementDimensions(sanitizeSize(childSize)))
  }

  public func quick_extractViewsIntoArray(_ views: inout [UIView]) {
    child.quick_extractViewsIntoArray(&views)
  }
}

private func sanitizeSize(_ s: CGSize) -> CGSize {
  CGSize(width: s.width.isFinite ? s.width : 0, height: s.height.isFinite ? s.height : 0)
}
