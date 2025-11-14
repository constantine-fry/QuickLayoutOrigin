/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation
import UIKit

public struct LayoutDirectionElement: Layout {

  private let child: Element
  private let layoutDirection: LayoutDirection

  public init(child: Element, layoutDirection: LayoutDirection) {
    self.child = child
    self.layoutDirection = layoutDirection
  }

  public func quick_layoutThatFits(_ proposedSize: CGSize) -> LayoutNode {
    LayoutContext.$layoutDirection.withValue(layoutDirection) {
      child.quick_layoutThatFits(proposedSize)
    }
  }

  public func quick_flexibility(for axis: Axis) -> Flexibility {
    LayoutContext.$layoutDirection.withValue(layoutDirection) {
      child.quick_flexibility(for: axis)
    }
  }

  public func quick_layoutPriority() -> CGFloat {
    child.quick_layoutPriority()
  }

  public func quick_extractViewsIntoArray(_ views: inout [UIView]) {
    child.quick_extractViewsIntoArray(&views)
  }
}
