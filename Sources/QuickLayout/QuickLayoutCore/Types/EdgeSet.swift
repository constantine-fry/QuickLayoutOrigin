/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation

public struct EdgeSet: OptionSet, Sendable {

  public let rawValue: Int8

  public init(rawValue: Int8) {
    self.rawValue = rawValue
  }

  public static let all: EdgeSet = [.top, .bottom, .leading, .trailing]
  public static let top = EdgeSet(rawValue: 1 << Edge.top.rawValue)
  public static let bottom = EdgeSet(rawValue: 1 << Edge.bottom.rawValue)
  public static let leading = EdgeSet(rawValue: 1 << Edge.leading.rawValue)
  public static let trailing = EdgeSet(rawValue: 1 << Edge.trailing.rawValue)
  public static let horizontal: EdgeSet = [.leading, .trailing]
  public static let vertical: EdgeSet = [.top, .bottom]
}
