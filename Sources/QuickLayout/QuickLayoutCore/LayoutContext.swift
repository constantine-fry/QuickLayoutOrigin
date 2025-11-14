/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation

public struct LayoutContext {

  @TaskLocal
  public static var layoutDirection: LayoutDirection = DefaultLayoutDirection.value

  @TaskLocal
  /// The main axis of nearest parent Stack. Used by Spacers to determine the main axis to grow.
  static var latestMainAxis: Axis = Axis.vertical
}
