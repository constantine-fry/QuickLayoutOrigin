/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation
import UIKit

public enum ContentMode {
  case fill
  case fit
}

public struct AspectRatioElement: Layout {

  private let child: Element
  private let aspectRatio: CGFloat
  private let contentMode: ContentMode

  public init(child: Element, aspectRatio: CGFloat, contentMode: ContentMode) {
    self.child = child
    self.contentMode = contentMode
    self.aspectRatio = aspectRatio
  }

  public func quick_flexibility(for axis: Axis) -> Flexibility {
    .partial
  }

  public func quick_layoutPriority() -> CGFloat {
    child.quick_layoutPriority()
  }

  public func quick_layoutThatFits(_ proposedSize: CGSize) -> LayoutNode {
    let newProposedSized = calculateNewSize(proposedSize, aspectRatio: aspectRatio, contentMode: contentMode)
    let childLayout = child.quick_layoutThatFits(newProposedSized)
    let size = CGSize(
      width: childLayout.size.width.isInfinite ? newProposedSized.width : childLayout.size.width,
      height: childLayout.size.height.isInfinite ? newProposedSized.height : childLayout.size.height
    )
    let childNode = LayoutNode.Child(position: .zero, layout: childLayout)
    let alignmentGuides = AlignmentGuidesResolver.extract(childNode)
    return LayoutNode(view: nil, size: size, children: [childNode], alignmentGuides: alignmentGuides)
  }

  public func quick_extractViewsIntoArray(_ views: inout [UIView]) {
    child.quick_extractViewsIntoArray(&views)
  }
}

private func calculateNewSize(_ proposedSize: CGSize, aspectRatio: CGFloat, contentMode: ContentMode) -> CGSize {
  if aspectRatio <= 0 || !aspectRatio.isFinite {
    return proposedSize
  }

  let isWidthFinite = proposedSize.width.isFinite
  let isHeightFinite = proposedSize.height.isFinite

  if !isWidthFinite && !isHeightFinite {
    return proposedSize
  }

  if !isWidthFinite {
    return CGSize(width: proposedSize.height * CGFloat(aspectRatio), height: proposedSize.height)
  }

  if !isHeightFinite {
    return CGSize(width: proposedSize.width, height: proposedSize.width / CGFloat(aspectRatio))
  }

  let proposedAspectRatio = proposedSize.width / proposedSize.height

  switch contentMode {
  case .fill:
    if proposedAspectRatio > aspectRatio {
      return CGSize(width: proposedSize.width, height: proposedSize.width / CGFloat(aspectRatio))
    } else {
      return CGSize(width: proposedSize.height * CGFloat(aspectRatio), height: proposedSize.height)
    }
  case .fit:
    if proposedAspectRatio > aspectRatio {
      return CGSize(width: proposedSize.height * CGFloat(aspectRatio), height: proposedSize.height)
    } else {
      return CGSize(width: proposedSize.width, height: proposedSize.width / CGFloat(aspectRatio))
    }
  }
}
