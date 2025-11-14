/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation
import UIKit

public struct FixedSizeElement: Layout {

  private let child: Element
  private let horizontal: Bool
  private let vertical: Bool

  public init(child: Element, horizontal: Bool, vertical: Bool) {
    self.child = child
    self.horizontal = horizontal
    self.vertical = vertical
  }

  public func quick_flexibility(for axis: Axis) -> Flexibility {
    switch axis {
    case .horizontal: horizontal ? .fixedSize : child.quick_flexibility(for: axis)
    case .vertical: vertical ? .fixedSize : child.quick_flexibility(for: axis)
    }
  }

  public func quick_layoutPriority() -> CGFloat {
    child.quick_layoutPriority()
  }

  public func quick_layoutThatFits(_ proposedSize: CGSize) -> LayoutNode {
    let newProposedSize = CGSize(
      width: horizontal ? .infinity : proposedSize.width,
      height: vertical ? .infinity : proposedSize.height
    )
    return child.quick_layoutThatFits(newProposedSize)
  }

  public func quick_extractViewsIntoArray(_ views: inout [UIView]) {
    child.quick_extractViewsIntoArray(&views)
  }
}
