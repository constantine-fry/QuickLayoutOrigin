/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation
import UIKit

public struct FlexibleFrameElement: Layout {

  private let child: Element
  private let minWidth: CGFloat?
  private let maxWidth: CGFloat?
  private let minHeight: CGFloat?
  private let maxHeight: CGFloat?
  private let alignment: Alignment

  public init(
    child: Element,
    minWidth: CGFloat?,
    maxWidth: CGFloat?,
    minHeight: CGFloat?,
    maxHeight: CGFloat?,
    alignment: Alignment = .center
  ) {
    self.child = child
    self.minWidth = sanitizedFrameDimension(minWidth)
    self.maxWidth = sanitizedFrameDimension(maxWidth)
    self.minHeight = sanitizedFrameDimension(minHeight)
    self.maxHeight = sanitizedFrameDimension(maxHeight)
    self.alignment = alignment
  }

  public func quick_flexibility(for axis: Axis) -> Flexibility {
    if axis == .horizontal && maxWidth != nil {
      return .partial
    }
    if axis == .vertical && maxHeight != nil {
      return .partial
    }
    return child.quick_flexibility(for: axis)
  }

  public func quick_layoutPriority() -> CGFloat {
    child.quick_layoutPriority()
  }

  public func quick_layoutThatFits(_ proposedSize: CGSize) -> LayoutNode {
    let clampedProposedSize = CGSize(
      width: clamp(proposedSize.width, minWidth, maxWidth),
      height: clamp(proposedSize.height, minHeight, maxHeight)
    )
    let layout = child.quick_layoutThatFits(clampedProposedSize)

    let size = CGSize(
      width: frameSize(childSize: layout.size.width, proposedSizeByParent: proposedSize.width, minFrameConstraint: minWidth, maxFrameConstraint: maxWidth),
      height: frameSize(childSize: layout.size.height, proposedSizeByParent: proposedSize.height, minFrameConstraint: minHeight, maxFrameConstraint: maxHeight)
    )

    let dimensions = ElementDimensions(size)

    let x = dimensions[alignment.horizontal] - layout.dimensions[alignment.horizontal]
    let y = dimensions[alignment.vertical] - layout.dimensions[alignment.vertical]
    let childNode = LayoutNode.Child(position: roundToPixelGrid(CGPoint(x: x, y: y)), layout: layout)
    let alignmentGuides = AlignmentGuidesResolver.extract(childNode)
    return LayoutNode(view: nil, size: size, children: [childNode], alignmentGuides: alignmentGuides)
  }

  public func quick_extractViewsIntoArray(_ views: inout [UIView]) {
    child.quick_extractViewsIntoArray(&views)
  }
}

private func sanitizedFrameDimension(_ width: CGFloat?) -> CGFloat? {
  guard let width else { return nil }
  return max(width, 0)
}

private func clamp(_ f: CGFloat, _ minNumber: CGFloat?, _ maxNumber: CGFloat?) -> CGFloat {
  let minValue = minNumber ?? 0
  let maxValue = maxNumber ?? .infinity
  return min(max(f, minValue), maxValue)
}

private func frameSize(childSize: CGFloat, proposedSizeByParent: CGFloat, minFrameConstraint: CGFloat?, maxFrameConstraint: CGFloat?) -> CGFloat {

  if minFrameConstraint == nil && maxFrameConstraint == nil {
    return childSize
  }

  if let minFrameConstraint, let maxFrameConstraint {
    if proposedSizeByParent.isFinite || maxFrameConstraint.isFinite {
      return clamp(proposedSizeByParent, minFrameConstraint, maxFrameConstraint)
    }
  }

  if let minFrameConstraint, proposedSizeByParent < childSize {
    return max(proposedSizeByParent, minFrameConstraint)
  }

  if let maxFrameConstraint, proposedSizeByParent > childSize {
    if proposedSizeByParent.isFinite || maxFrameConstraint.isFinite {
      return min(proposedSizeByParent, maxFrameConstraint)
    }
  }

  return clamp(childSize, minFrameConstraint, maxFrameConstraint)
}
