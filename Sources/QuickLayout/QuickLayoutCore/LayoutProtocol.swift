/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation
import UIKit

/// Convienence API to work with the root element.
public protocol Layout: Element {

  /// Calculates the size, taking into account the proposed size and properties of the views or view proxies.
  ///
  /// **Thread Safety:**
  /// - If the layout contains `UIView` instances, this method must be called on the main thread to ensure proper rendering and avoid potential crashes.
  /// - If the layout consists only of thread-safe `ViewProxy` objects, this method can be safely invoked from any thread.
  /// - However, some `ViewProxy` subclasses, such as `UILabel.proxy`, are not thread-safe. In these cases, calling this method from the main thread is required to prevent unexpected behavior.
  /// It's essential to consider the thread safety of your layout components when invoking this method to ensure correct functionality and avoid potential issues.
  func sizeThatFits(_ proposedSize: CGSize) -> CGSize

  /// Applies the layout to the containing views.
  ///
  /// **Thread Safety:**
  /// This method must be called on the main thread.
  @MainActor
  func applyFrame(_ frame: CGRect, alignment: Alignment, layoutDirection: LayoutDirection?)

  func views() -> [UIView]
}

public extension Layout {

  @MainActor
  func applyFrame(_ frame: CGRect) {
    applyFrame(frame, alignment: .center, layoutDirection: nil)
  }

  @MainActor
  func applyFrame(_ frame: CGRect, alignment: Alignment) {
    applyFrame(frame, alignment: alignment, layoutDirection: nil)
  }
}
