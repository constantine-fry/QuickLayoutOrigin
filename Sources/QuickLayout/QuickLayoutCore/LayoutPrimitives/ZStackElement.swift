/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation
import UIKit

public struct ZStackElement: Layout {

  private let children: [Element]
  private let alignment: Alignment

  public init(
    children: [Element],
    alignment: Alignment = .center
  ) {
    self.children = children
    self.alignment = alignment
  }

  public func quick_flexibility(for axis: Axis) -> Flexibility {
    var result = Flexibility.fixedSize
    for child in children {
      let flexibility = child.quick_flexibility(for: axis)
      if flexibility.rawValue > result.rawValue {
        result = flexibility
      }
    }
    return result
  }

  public func quick_layoutPriority() -> CGFloat {
    0
  }

  public func quick_layoutThatFits(_ proposedSize: CGSize) -> LayoutNode {
    let childrenCount = children.count
    if childrenCount == 0 {
      return LayoutNode.empty
    }
    if childrenCount == 1 {
      let childLayout = children[0].quick_layoutThatFits(proposedSize)
      let childNode = LayoutNode.Child(position: .zero, layout: childLayout)
      return LayoutNode(view: nil, size: childLayout.size, children: [childNode], alignmentGuides: AlignmentGuidesResolver.extract(childNode))
    }

    var maxHorizontalAlignmentGuideLength = -CGFloat.greatestFiniteMagnitude
    var maxVerticalAlignmentGuideLength = -CGFloat.greatestFiniteMagnitude
    let childLayouts = children.map { child in
      let layout = child.quick_layoutThatFits(proposedSize)
      maxHorizontalAlignmentGuideLength = max(maxHorizontalAlignmentGuideLength, layout.dimensions[alignment.horizontal])
      maxVerticalAlignmentGuideLength = max(maxVerticalAlignmentGuideLength, layout.dimensions[alignment.vertical])
      return layout
    }

    var resultFrame = CGRect.zero
    let childNodes: [LayoutNode.Child] = childLayouts.map { layout in
      let x = maxHorizontalAlignmentGuideLength - layout.dimensions[alignment.horizontal]
      let y = maxVerticalAlignmentGuideLength - layout.dimensions[alignment.vertical]
      let childNode = LayoutNode.Child(position: sanitizePoint(CGPoint(x: x, y: y)), layout: layout)
      resultFrame = resultFrame.union(CGRect(origin: childNode.position, size: childNode.layout.size))
      return childNode
    }
    return LayoutNode(view: nil, size: resultFrame.size, children: childNodes, alignmentGuides: AlignmentGuidesResolver.extract(for: childNodes))
  }

  public func quick_extractViewsIntoArray(_ views: inout [UIView]) {
    children.forEach { child in
      child.quick_extractViewsIntoArray(&views)
    }
  }
}

private func sanitizePoint(_ p: CGPoint) -> CGPoint {
  CGPoint(x: p.x.isNaN ? 0.0 : p.x, y: p.y.isNaN ? 0.0 : p.y)
}
