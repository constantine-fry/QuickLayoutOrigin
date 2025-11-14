/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation

public struct AxisSet: OptionSet, Sendable {
  public let rawValue: Int8

  public init(rawValue: Int8) {
    self.rawValue = rawValue
  }

  public static let horizontal = AxisSet(rawValue: 1 << 0)
  public static let vertical = AxisSet(rawValue: 1 << 1)
}
