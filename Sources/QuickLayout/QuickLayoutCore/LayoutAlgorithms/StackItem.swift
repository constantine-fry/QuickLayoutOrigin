/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation

struct StackItem {
  static let empty = StackItem()

  let premeasure: Bool
  var premeasuredMain: CGFloat

  init(
    premeasure: Bool = false,
    premeasuredMain: CGFloat = .infinity
  ) {
    self.premeasure = premeasure
    self.premeasuredMain = premeasuredMain
  }
}
