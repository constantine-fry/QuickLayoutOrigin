/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation
import UIKit

public struct EmptyElement: Layout {

  public init() {}

  public func quick_flexibility(for axis: Axis) -> Flexibility {
    .fixedSize
  }

  public func quick_layoutPriority() -> CGFloat {
    CGFloat.infinity
  }

  public func quick_layoutThatFits(_ proposedSize: CGSize) -> LayoutNode {
    LayoutNode.empty
  }

  public func quick_extractViewsIntoArray(_ views: inout [UIView]) {
    // no-op
  }
}
