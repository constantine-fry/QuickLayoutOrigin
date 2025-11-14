/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation

/**
 AlignmentID can be used to define a custom alignment behavior.
 */
public protocol AlignmentID: Sendable {
  static func defaultValue(in context: ElementDimensions) -> CGFloat
}

public struct AnyAlignmentID: Hashable, Sendable {
  private let alignmentID: AlignmentID.Type
  internal let axis: Axis

  init(_ alignmentID: AlignmentID.Type, axis: Axis) {
    self.alignmentID = alignmentID
    self.axis = axis
  }

  func defaultValue(in context: ElementDimensions) -> CGFloat {
    alignmentID.defaultValue(in: context)
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(ObjectIdentifier(alignmentID))
  }

  public static func == (lhs: AnyAlignmentID, rhs: AnyAlignmentID) -> Bool {
    return ObjectIdentifier(lhs.alignmentID) == ObjectIdentifier(rhs.alignmentID)
  }
}

// MARK: - Vertical Alignment IDs

private struct TopAlignment: AlignmentID {
  static func defaultValue(in context: ElementDimensions) -> CGFloat {
    0
  }
}

private struct VerticalCenterAlignment: AlignmentID {
  static func defaultValue(in context: ElementDimensions) -> CGFloat {
    context.height / 2
  }
}

private struct BottomAlignment: AlignmentID {
  static func defaultValue(in context: ElementDimensions) -> CGFloat {
    context.height
  }
}

public extension VerticalAlignment {
  static let top = VerticalAlignment(TopAlignment.self)
  static let center = VerticalAlignment(VerticalCenterAlignment.self)
  static let bottom = VerticalAlignment(BottomAlignment.self)
}

// MARK: - Horizontal Alignment IDs

private struct LeadingAlignment: AlignmentID {
  static func defaultValue(in context: ElementDimensions) -> CGFloat {
    LayoutContext.layoutDirection == .rightToLeft ? context.width : 0
  }
}

private struct HorizontalCenterAlignment: AlignmentID {
  static func defaultValue(in context: ElementDimensions) -> CGFloat {
    context.width / 2
  }
}

private struct TrailingAlignment: AlignmentID {
  static func defaultValue(in context: ElementDimensions) -> CGFloat {
    LayoutContext.layoutDirection == .rightToLeft ? 0 : context.width
  }
}

public extension HorizontalAlignment {
  static let leading = HorizontalAlignment(LeadingAlignment.self)
  static let center = HorizontalAlignment(HorizontalCenterAlignment.self)
  static let trailing = HorizontalAlignment(TrailingAlignment.self)
}
