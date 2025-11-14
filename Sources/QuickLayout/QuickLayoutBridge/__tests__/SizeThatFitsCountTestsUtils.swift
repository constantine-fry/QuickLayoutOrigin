/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import QuickLayoutBridge
import QuickLayoutCore
import UIKit
import XCTest

class FixedSizeViewView: UIView {

  var sizeThatFitsCounter = 0
  private let intrinsicSize: CGSize?

  init(intrinsicSize: CGSize? = nil) {
    self.intrinsicSize = intrinsicSize
    super.init(frame: .zero)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // Fully flexible if no intrinsic size is set.
  override func sizeThatFits(_ size: CGSize) -> CGSize {
    sizeThatFitsCounter += 1
    return intrinsicSize ?? size
  }

  override var intrinsicContentSize: CGSize {
    return intrinsicSize ?? .zero
  }
}

class CountedLabel: UILabel {
  var sizeThatFitsCounter = 0
  override func sizeThatFits(_ size: CGSize) -> CGSize {
    sizeThatFitsCounter += 1
    return super.sizeThatFits(size)
  }
}
