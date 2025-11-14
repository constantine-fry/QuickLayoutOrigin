/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation
import UIKit

public struct OffsetElement: Layout {

  private let child: Element
  private let offset: CGPoint

  public init(child: Element, offset: CGPoint) {
    self.child = child
    self.offset = sanitizeOffset(offset)
  }

  public func quick_flexibility(for axis: Axis) -> Flexibility {
    child.quick_flexibility(for: axis)
  }

  public func quick_layoutPriority() -> CGFloat {
    child.quick_layoutPriority()
  }

  public func quick_layoutThatFits(_ proposedSize: CGSize) -> LayoutNode {
    var offset = self.offset
    if LayoutContext.layoutDirection == .rightToLeft {
      offset = CGPoint(x: -offset.x, y: offset.y)
    }
    let childLayout = child.quick_layoutThatFits(proposedSize)
    let childNode = LayoutNode.Child(position: offset, layout: childLayout)
    let alignmentGuides = AlignmentGuidesResolver.extract(childNode)
    return LayoutNode(view: nil, size: childLayout.size, children: [childNode], alignmentGuides: alignmentGuides)
  }

  public func quick_extractViewsIntoArray(_ views: inout [UIView]) {
    child.quick_extractViewsIntoArray(&views)
  }
}

private func sanitizeOffset(_ offset: CGPoint) -> CGPoint {
  CGPoint(x: offset.x.isFinite ? offset.x : 0, y: offset.y.isFinite ? offset.y : 0)
}
