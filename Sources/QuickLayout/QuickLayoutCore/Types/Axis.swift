/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation

@objc(QLAxis)
@frozen
public enum Axis: Int8, Sendable {
  case horizontal
  case vertical
}
