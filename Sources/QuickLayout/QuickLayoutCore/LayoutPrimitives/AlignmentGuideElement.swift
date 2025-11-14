/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation
import UIKit

public struct AlignmentGuideElement: Layout {
  private let child: Element
  private let alignmentID: AnyAlignmentID
  private let computeValue: @Sendable (ElementDimensions) -> CGFloat

  public init(child: Element, horizontalAlignment: HorizontalAlignment, computeValue: @escaping @Sendable (ElementDimensions) -> CGFloat) {
    self.init(child: child, alignmentID: horizontalAlignment.alignmentID, computeValue: computeValue)
  }

  public init(child: Element, verticalAlignment: VerticalAlignment, computeValue: @escaping @Sendable (ElementDimensions) -> CGFloat) {
    self.init(child: child, alignmentID: verticalAlignment.alignmentID, computeValue: computeValue)
  }

  init(child: Element, alignmentID: AnyAlignmentID, computeValue: @escaping @Sendable (ElementDimensions) -> CGFloat) {
    self.child = child
    self.alignmentID = alignmentID
    self.computeValue = computeValue
  }

  public func quick_flexibility(for axis: Axis) -> Flexibility {
    child.quick_flexibility(for: axis)
  }

  public func quick_layoutPriority() -> CGFloat {
    child.quick_layoutPriority()
  }

  public func quick_layoutThatFits(_ proposedSize: CGSize) -> LayoutNode {
    let childLayout = child.quick_layoutThatFits(proposedSize)
    let childNode = LayoutNode.Child(position: .zero, layout: childLayout)

    var alignmentGuides = AlignmentGuidesResolver.extract(childNode)
    alignmentGuides[alignmentID] = computeValue

    return LayoutNode(
      view: nil,
      size: childLayout.size,
      children: [childNode],
      alignmentGuides: alignmentGuides
    )
  }

  public func quick_extractViewsIntoArray(_ views: inout [UIView]) {
    child.quick_extractViewsIntoArray(&views)
  }
}
