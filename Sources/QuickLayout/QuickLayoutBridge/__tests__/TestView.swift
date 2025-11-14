/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import UIKit

final class TestView: UIView {

  var sizeThatFitsCounter = 0
  var sizeThatFitsBlock: ((CGSize) -> CGSize)?

  override func sizeThatFits(_ size: CGSize) -> CGSize {
    sizeThatFitsCounter += 1
    return sizeThatFitsBlock?(size) ?? .zero
  }
}
