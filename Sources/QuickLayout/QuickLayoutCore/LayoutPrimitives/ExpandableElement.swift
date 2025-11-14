/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation
import UIKit

public struct ExpandableElement: Layout {

  private let child: LeafElement
  private let size: CGSize

  public init(child: LeafElement, size: CGSize) {
    self.child = child
    self.size = sanitizeInputSize(size)
  }

  public func quick_flexibility(for axis: Axis) -> Flexibility {
    child.quick_flexibility(for: axis)
  }

  public func quick_layoutPriority() -> CGFloat {
    child.quick_layoutPriority()
  }

  public func quick_layoutThatFits(_ proposedSize: CGSize) -> LayoutNode {
    let childLayout = child.quick_layoutThatFits(proposedSize)
    let expandedSize = CGSize(width: size.width + childLayout.size.width, height: size.height + childLayout.size.height)
    return LayoutNode(view: childLayout.view, dimensions: ElementDimensions(sanitizeOutputSize(expandedSize)))
  }

  public func quick_extractViewsIntoArray(_ views: inout [UIView]) {
    child.quick_extractViewsIntoArray(&views)
  }
}

private func sanitizeInputSize(_ size: CGSize) -> CGSize {
  CGSize(width: size.width.isFinite ? size.width : 0, height: size.height.isFinite ? size.height : 0)
}

private func sanitizeOutputSize(_ size: CGSize) -> CGSize {
  CGSize(width: max(size.width, 0), height: max(size.height, 0))
}
