/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation
import UIKit

public struct LayoutPriorityElement: Element {

  private let child: Element
  private let layoutPriority: CGFloat

  public init(child: Element, layoutPriority: CGFloat) {
    self.child = child
    self.layoutPriority = layoutPriority
  }

  public func quick_flexibility(for axis: Axis) -> Flexibility {
    child.quick_flexibility(for: axis)
  }

  public func quick_layoutPriority() -> CGFloat {
    layoutPriority
  }

  public func quick_layoutThatFits(_ proposedSize: CGSize) -> LayoutNode {
    child.quick_layoutThatFits(proposedSize)
  }

  public func quick_extractViewsIntoArray(_ views: inout [UIView]) {
    child.quick_extractViewsIntoArray(&views)
  }
}
