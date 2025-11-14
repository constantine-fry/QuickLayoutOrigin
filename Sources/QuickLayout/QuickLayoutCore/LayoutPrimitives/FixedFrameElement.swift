/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation
import UIKit

public struct FixedFrameElement: Layout {

  private let child: Element
  private let width: CGFloat?
  private let height: CGFloat?
  private let alignment: Alignment

  public init(
    child: Element,
    width: CGFloat? = nil,
    height: CGFloat? = nil,
    alignment: Alignment = .center
  ) {
    self.child = child
    self.width = sanitizedFrameDimension(width)
    self.height = sanitizedFrameDimension(height)
    self.alignment = alignment
  }

  public func quick_flexibility(for axis: Axis) -> Flexibility {
    switch axis {
    case .horizontal: width != nil ? .fixedSize : child.quick_flexibility(for: axis)
    case .vertical: height != nil ? .fixedSize : child.quick_flexibility(for: axis)
    }
  }

  public func quick_layoutPriority() -> CGFloat {
    child.quick_layoutPriority()
  }

  public func quick_layoutThatFits(_ proposedSize: CGSize) -> LayoutNode {
    let proposedSize = CGSize(
      width: width ?? proposedSize.width,
      height: height ?? proposedSize.height
    )
    let layout = child.quick_layoutThatFits(proposedSize)

    let size = CGSize(width: width ?? layout.size.width, height: height ?? layout.size.height)
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
  guard let width, width.isFinite else { return nil }
  return max(width, 0)
}
