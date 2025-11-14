/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation

/**
 ElementDimensions is used to store dimensional information,
 including sizing and alignment info.
 */
public struct ElementDimensions: Sendable {
  public let width: CGFloat
  public let height: CGFloat
  internal let alignmentGuides: AlignmentGuides

  // MARK: - Public API

  public init(_ size: CGSize) {
    self.init(size, alignmentGuides: AlignmentGuidesResolver.none())
  }

  public subscript(_ horizontalAlignment: HorizontalAlignment) -> CGFloat {
    self[horizontalAlignment.alignmentID]
  }

  public subscript(_ verticalAlignment: VerticalAlignment) -> CGFloat {
    self[verticalAlignment.alignmentID]
  }

  // MARK: - Internal API

  internal init(_ size: CGSize, alignmentGuides: AlignmentGuides) {
    self.width = size.width
    self.height = size.height
    self.alignmentGuides = alignmentGuides
  }

  internal subscript(_ alignmentID: AnyAlignmentID) -> CGFloat {
    let resolvedValue = self[explicit: alignmentID] ?? alignmentID.defaultValue(in: self)
    let sanitizedValue = (resolvedValue.isInfinite || resolvedValue.isNaN) ? 0 : resolvedValue
    return sanitizedValue
  }

  // MARK: - Private

  private subscript(explicit alignmentID: AnyAlignmentID) -> CGFloat? {
    guard let alignmentGuide = alignmentGuides[alignmentID] else {
      return nil
    }
    // If the alignment guide requests the value it is aligned against,
    // return the default value instead of recursing.
    let dimensions = ElementDimensions(
      CGSize(width: width, height: height),
      alignmentGuides: alignmentGuides.disregarding(alignmentID)
    )
    return alignmentGuide(dimensions)
  }
}
