/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation
import UIKit

public enum LayeringType {
  case background
  case overlay
}

public struct LayeringElement: Layout {

  private let type: LayeringType
  private let target: Element
  private let layer: Element
  private let alignment: Alignment

  public init(
    target: Element,
    layer: Element,
    type: LayeringType,
    alignment: Alignment = .center
  ) {
    self.type = type
    self.target = target
    self.layer = layer
    self.alignment = alignment
  }

  public func quick_flexibility(for axis: Axis) -> Flexibility {
    target.quick_flexibility(for: axis)
  }

  public func quick_layoutPriority() -> CGFloat {
    target.quick_layoutPriority()
  }

  public func quick_layoutThatFits(_ proposedSize: CGSize) -> LayoutNode {
    let targetLayout = target.quick_layoutThatFits(proposedSize)
    let layerLayout = layer.quick_layoutThatFits(targetLayout.size)

    let x = targetLayout.dimensions[alignment.horizontal] - layerLayout.dimensions[alignment.horizontal]
    let y = targetLayout.dimensions[alignment.vertical] - layerLayout.dimensions[alignment.vertical]
    let targetChild = LayoutNode.Child(position: .zero, layout: targetLayout)
    let alignmentGuides = AlignmentGuidesResolver.extract(targetChild)

    return LayoutNode(
      view: nil,
      size: targetLayout.size,
      children: [
        targetChild,
        LayoutNode.Child(position: roundToPixelGrid(CGPoint(x: x, y: y)), layout: layerLayout),
      ],
      alignmentGuides: alignmentGuides
    )
  }

  public func quick_extractViewsIntoArray(_ views: inout [UIView]) {
    switch type {
    case .background:
      layer.quick_extractViewsIntoArray(&views)
      target.quick_extractViewsIntoArray(&views)
    case .overlay:
      target.quick_extractViewsIntoArray(&views)
      layer.quick_extractViewsIntoArray(&views)
    }
  }
}

private func sanitizePoint(_ p: CGPoint) -> CGPoint {
  CGPoint(x: p.x.isNaN ? 0.0 : p.x, y: p.y.isNaN ? 0.0 : p.y)
}
