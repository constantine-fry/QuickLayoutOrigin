/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation
import UIKit

/// Every element that can be laid out must conform to this protocol.
public protocol Element {
  func quick_layoutThatFits(_ proposedSize: CGSize) -> LayoutNode
  func quick_flexibility(for axis: Axis) -> Flexibility
  func quick_layoutPriority() -> CGFloat
  func quick_extractViewsIntoArray(_ views: inout [UIView])
  func quickInternal_isSpacer() -> Bool
}

public extension Element {
  func quickInternal_isSpacer() -> Bool {
    false
  }
}

/// Marker protocol for layout elements that should manage only leaf elements
/// such as UIViews or ViewProxies.
public protocol LeafElement: Element {
  func backingView() -> UIView?
}
