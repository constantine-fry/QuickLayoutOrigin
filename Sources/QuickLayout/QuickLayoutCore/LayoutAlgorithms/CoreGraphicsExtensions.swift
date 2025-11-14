/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import CoreGraphics

extension CGPoint {
  init(main: CGFloat, cross: CGFloat, mainAxis: Axis) {
    switch mainAxis {
    case .horizontal: self.init(x: main, y: cross)
    case .vertical: self.init(x: cross, y: main)
    }
  }
}

extension CGSize {
  init(main: CGFloat, cross: CGFloat, mainAxis: Axis) {
    switch mainAxis {
    case .horizontal: self.init(width: main, height: cross)
    case .vertical: self.init(width: cross, height: main)
    }
  }

  func replaceCross(with value: CGFloat, mainAxis: Axis) -> CGSize {
    switch mainAxis {
    case .horizontal: CGSize(width: width, height: value)
    case .vertical: CGSize(width: value, height: height)
    }
  }

  func main(for axis: Axis) -> CGFloat {
    switch axis {
    case .horizontal: width
    case .vertical: height
    }
  }

  func cross(for axis: Axis) -> CGFloat {
    switch axis {
    case .horizontal: height
    case .vertical: width
    }
  }
}
