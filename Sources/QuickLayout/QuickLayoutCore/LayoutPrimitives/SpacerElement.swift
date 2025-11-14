/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation
import UIKit

public struct SpacerElement: Element {

  private let length: CGFloat?

  public init(length: CGFloat? = nil) {
    self.length = length
  }

  public func quickInternal_isSpacer() -> Bool {
    return true
  }

  public func quick_flexibility(for axis: Axis) -> Flexibility {
    if length == nil {
      let mainAxis = LayoutContext.latestMainAxis
      return axis == mainAxis ? .fullyFlexible : .fixedSize
    }
    return .fixedSize
  }

  public func quick_layoutPriority() -> CGFloat {
    length == nil ? -CGFloat.infinity : CGFloat.infinity
  }

  public func quick_layoutThatFits(_ proposedSize: CGSize) -> LayoutNode {
    let mainAxis = LayoutContext.latestMainAxis

    let size =
      switch mainAxis {
      case .horizontal: CGSize(width: length ?? proposedSize.width, height: 0)
      case .vertical: CGSize(width: 0, height: length ?? proposedSize.height)
      }
    return LayoutNode(view: nil, dimensions: ElementDimensions(sanitizeSize(size)))
  }

  public func quick_extractViewsIntoArray(_ views: inout [UIView]) {
    // no-op
  }
}

private func sanitizeSize(_ s: CGSize) -> CGSize {
  CGSize(width: s.width.isFinite ? s.width : 0, height: s.height.isFinite ? s.height : 0)
}
