/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation
import UIKit

@objc
public enum LayoutDirection: Int8, Sendable {
  case leftToRight
  case rightToLeft
}

struct DefaultLayoutDirection {
  static let value: LayoutDirection = NSParagraphStyle.defaultWritingDirection(forLanguage: nil) == .rightToLeft ? .rightToLeft : .leftToRight
}
