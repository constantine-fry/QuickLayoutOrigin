/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation
import UIKit

public struct PaddingElement: Layout {

  private let child: Element
  private let insets: UIEdgeInsets
  private let respectLayoutDirection: Bool

  public init(child: Element, insets: UIEdgeInsets) {
    self.respectLayoutDirection = false
    self.insets = sanitizeInsets(insets)
    self.child = child
  }

  public init(child: Element, value: CGFloat) {
    self.respectLayoutDirection = false
    self.insets = sanitizedInsets(value)
    self.child = child
  }

  public init(child: Element, horizontal: CGFloat, vertical: CGFloat) {
    self.respectLayoutDirection = false
    self.insets = sanitizedInsets(h: horizontal, v: vertical)
    self.child = child
  }

  public init(child: Element, edges: EdgeSet, length: CGFloat) {
    let insets = EdgeInsets(
      top: edges.contains(.top) ? length : 0,
      leading: edges.contains(.leading) ? length : 0,
      bottom: edges.contains(.bottom) ? length : 0,
      trailing: edges.contains(.trailing) ? length : 0
    )
    self.init(child: child, insets: insets)
  }

  public init(child: Element, insets: EdgeInsets) {
    let insets = UIEdgeInsets(top: insets.top, left: insets.leading, bottom: insets.bottom, right: insets.trailing)
    self.respectLayoutDirection = true
    self.insets = sanitizeInsets(insets)
    self.child = child
  }

  public func quick_flexibility(for axis: Axis) -> Flexibility {
    child.quick_flexibility(for: axis)
  }

  public func quick_layoutPriority() -> CGFloat {
    child.quick_layoutPriority()
  }

  public func quick_layoutThatFits(_ proposedSize: CGSize) -> LayoutNode {
    var insets = self.insets
    if respectLayoutDirection && LayoutContext.layoutDirection == .rightToLeft {
      insets = UIEdgeInsets(top: insets.top, left: insets.right, bottom: insets.bottom, right: insets.left)
    }
    let childProposedSize = CGSize(
      width: max(proposedSize.width - insets.left - insets.right, 0),
      height: max(proposedSize.height - insets.top - insets.bottom, 0)
    )
    let childLayout = child.quick_layoutThatFits(childProposedSize)
    let selfSize = CGSize(
      width: childLayout.size.width + insets.left + insets.right,
      height: childLayout.size.height + insets.top + insets.bottom
    )

    let childNode = LayoutNode.Child(position: CGPoint(x: insets.left, y: insets.top), layout: childLayout)
    let alignmentGuides = AlignmentGuidesResolver.extract(childNode)
    return LayoutNode(view: nil, size: selfSize, children: [childNode], alignmentGuides: alignmentGuides)
  }

  public func quick_extractViewsIntoArray(_ views: inout [UIView]) {
    child.quick_extractViewsIntoArray(&views)
  }
}

private func sanitizeInsets(_ insets: UIEdgeInsets) -> UIEdgeInsets {
  UIEdgeInsets(
    top: insets.top.isFinite ? insets.top : 0,
    left: insets.left.isFinite ? insets.left : 0,
    bottom: insets.bottom.isFinite ? insets.bottom : 0,
    right: insets.right.isFinite ? insets.right : 0
  )
}

private func sanitizedInsets(_ value: CGFloat) -> UIEdgeInsets {
  let value = value.isFinite ? value : 0
  return UIEdgeInsets(top: value, left: value, bottom: value, right: value)
}

private func sanitizedInsets(h: CGFloat, v: CGFloat) -> UIEdgeInsets {
  let h = h.isFinite ? h : 0
  let v = v.isFinite ? v : 0
  return UIEdgeInsets(top: v, left: h, bottom: v, right: h)
}
