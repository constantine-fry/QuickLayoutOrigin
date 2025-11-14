/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

@objc(QLFlexibility)
public enum Flexibility: Int8, Sendable {
  case fixedSize
  case partial
  case fullyFlexible
}

@inlinable
public func max(_ a: Flexibility, _ b: Flexibility) -> Flexibility {
  a.rawValue > b.rawValue ? a : b
}
