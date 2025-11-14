/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import QuickLayoutBridge
import UIKit

/// Vertically self-sizing scroll view that grows up to the content height.
/// It allows the parent to compress itself below the content's height but never grows larger than the content.
/// Same as FOASelfSizingScrollView.
public final class TestSelfSizingScrollView: UIScrollView {
  public enum ScrollableAxis {
    case vertical, horizontal
  }

  public var scrollableAxis = ScrollableAxis.vertical
  public var scrollableContentLayout: (() -> (Element & Layout)?)?

  override public func layoutSubviews() {
    super.layoutSubviews()
    guard let layout = scrollableContentLayout?() else { return }

    switch scrollableAxis {
    case .vertical:
      self.contentSize = layout.sizeThatFits(CGSize(width: bounds.width, height: .infinity))
      layout.applyFrame(CGRect(x: 0, y: 0, width: bounds.width, height: .infinity))
    case .horizontal:
      self.contentSize = layout.sizeThatFits(CGSize(width: .infinity, height: bounds.height))
      layout.applyFrame(CGRect(x: 0, y: 0, width: .infinity, height: bounds.height))
    }
  }

  override public func sizeThatFits(_ proposedSize: CGSize) -> CGSize {
    guard let layout = scrollableContentLayout?() else { return proposedSize }

    switch scrollableAxis {
    case .vertical:
      let contentSize = layout.sizeThatFits(CGSize(width: proposedSize.width, height: .infinity))
      return CGSize(width: contentSize.width, height: min(proposedSize.height, contentSize.height))
    case .horizontal:
      let contentSize = layout.sizeThatFits(CGSize(width: .infinity, height: proposedSize.height))
      return CGSize(width: min(proposedSize.width, contentSize.width), height: contentSize.height)
    }
  }
}
