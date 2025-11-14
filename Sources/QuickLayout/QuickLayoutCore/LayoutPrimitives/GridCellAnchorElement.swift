/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation
import UIKit

public struct GridCellAnchorElement: Layout {

  private let child: Element
  public let alignment: Alignment?
  public let unitPoint: UnitPoint?

  public init(child: Element, alignment: Alignment? = nil, unitPoint: UnitPoint? = nil) {
    self.child = child
    self.alignment = alignment
    self.unitPoint = unitPoint
  }

  public func quick_layoutThatFits(_ proposedSize: CGSize) -> LayoutNode {
    let childLayout = child.quick_layoutThatFits(proposedSize)

    let gridInfo = GridInfo(alignment: alignment, unitPoint: unitPoint, columnAlignment: nil)

    return LayoutNode(
      view: childLayout.view,
      dimensions: childLayout.dimensions,
      gridInfo: gridInfo,
      children: childLayout.children
    )
  }

  public func quick_flexibility(for axis: Axis) -> Flexibility {
    return child.quick_flexibility(for: axis)
  }

  public func quick_layoutPriority() -> CGFloat {
    0
  }

  public func quick_extractViewsIntoArray(_ views: inout [UIView]) {
    child.quick_extractViewsIntoArray(&views)
  }

}
