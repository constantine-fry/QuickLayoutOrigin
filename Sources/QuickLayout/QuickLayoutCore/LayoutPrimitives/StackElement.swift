/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation
import UIKit

public struct StackElement: Layout {

  public let children: [Element]
  public let mainAxis: Axis
  public let spacing: CGFloat
  public let alignmentID: AnyAlignmentID
  public let idealLayoutEnabled: Bool

  public static func verticalStack(children: [Element], spacing: CGFloat = 0, alignment: HorizontalAlignment) -> StackElement {
    StackElement(children: children, mainAxis: .vertical, spacing: spacing, alignmentID: alignment.alignmentID)
  }

  public static func horizontalStack(children: [Element], spacing: CGFloat = 0, alignment: VerticalAlignment) -> StackElement {
    StackElement(children: children, mainAxis: .horizontal, spacing: spacing, alignmentID: alignment.alignmentID)
  }

  public init(children: [Element], mainAxis: Axis, spacing: CGFloat, alignmentID: AnyAlignmentID, idealLayout: Bool = false) {
    self.children = children
    self.mainAxis = mainAxis
    self.spacing = sanitizeSpacing(spacing)
    self.alignmentID = alignmentID
    self.idealLayoutEnabled = idealLayout
  }

  public func quick_flexibility(for axis: Axis) -> Flexibility {
    if children.isEmpty {
      return .fixedSize
    }

    var result = Flexibility.fixedSize
    LayoutContext.$latestMainAxis.withValue(mainAxis) {
      for child in children {
        let flexibility = child.quick_flexibility(for: axis)
        if flexibility.rawValue > result.rawValue {
          result = flexibility
        }
        if result == .fullyFlexible {
          break
        }
      }
    }

    return result
  }

  public func quick_layoutPriority() -> CGFloat {
    0
  }

  public func quick_layoutThatFits(_ proposedSize: CGSize) -> LayoutNode {
    if children.isEmpty {
      return LayoutNode.empty
    }

    return LayoutContext.$latestMainAxis.withValue(mainAxis) {
      computeStackLayout(
        children: children,
        alignment: alignmentID,
        mainAxis: mainAxis,
        spacing: spacing,
        proposedSize: proposedSize,
        idealLayout: idealLayoutEnabled
      )
    }
  }

  public func quick_extractViewsIntoArray(_ views: inout [UIView]) {
    children.forEach { child in
      child.quick_extractViewsIntoArray(&views)
    }
  }
}

private func sanitizeSpacing(_ spacing: CGFloat) -> CGFloat {
  spacing.isFinite ? spacing : 0
}
