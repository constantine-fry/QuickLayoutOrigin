/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation

public struct EdgeInsets: Sendable {

  public var top: CGFloat
  public var bottom: CGFloat
  public var leading: CGFloat
  public var trailing: CGFloat

  public static let zero = EdgeInsets()

  public init() {
    self.top = 0
    self.leading = 0
    self.bottom = 0
    self.trailing = 0
  }

  public init(top: CGFloat, leading: CGFloat, bottom: CGFloat, trailing: CGFloat) {
    self.top = top
    self.leading = leading
    self.bottom = bottom
    self.trailing = trailing
  }
}
