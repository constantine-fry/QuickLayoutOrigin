/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation
import UIKit

public struct GridElement: Layout {

  private let rows: [GridRowElement]
  private let alignment: Alignment
  private let horizontalSpacing: CGFloat
  private let verticalSpacing: CGFloat

  public init(rows: [GridRowElement], alignment: Alignment, horizontalSpacing: CGFloat, verticalSpacing: CGFloat) {
    self.rows = rows
    self.alignment = alignment
    self.horizontalSpacing = sanitizeSpacing(horizontalSpacing)
    self.verticalSpacing = sanitizeSpacing(verticalSpacing)
  }

  public func quick_flexibility(for axis: Axis) -> Flexibility {
    var maxFlexibility = Flexibility.fixedSize
    for row in rows {
      for child in row.children {
        let childFlex = child.quick_flexibility(for: axis)
        if childFlex.rawValue > maxFlexibility.rawValue {
          maxFlexibility = childFlex
        }
        if maxFlexibility == .fullyFlexible {
          return maxFlexibility
        }
      }
    }
    return maxFlexibility
  }

  public func quick_layoutPriority() -> CGFloat {
    0
  }

  public func quick_layoutThatFits(_ proposedSize: CGSize) -> LayoutNode {
    return computeGridLayout(rows: rows, alignment: alignment, proposedSize: proposedSize, verticalSpacing: verticalSpacing, horizontalSpacing: horizontalSpacing)
  }

  public func quick_extractViewsIntoArray(_ views: inout [UIView]) {
    rows.forEach { row in
      row.children.forEach { $0.quick_extractViewsIntoArray(&views) }
    }
  }
}

public struct GridRowElement {

  public let children: [Element]
  public let alignment: VerticalAlignment?

  public init(children: [Element], alignment: VerticalAlignment?) {
    self.children = children
    self.alignment = alignment
  }

  public func quick_layoutPriority() -> CGFloat {
    0
  }
}

private func sanitizeSpacing(_ spacing: CGFloat) -> CGFloat {
  (spacing.isFinite && spacing > 0) ? spacing : 0
}
