/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation

public struct UnitPoint: Sendable {

  public let x: CGFloat
  public let y: CGFloat

  public init(x: CGFloat, y: CGFloat) {
    self.x = x
    self.y = y
  }

}
