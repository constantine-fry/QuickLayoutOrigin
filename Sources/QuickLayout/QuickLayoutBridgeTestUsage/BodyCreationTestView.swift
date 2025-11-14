/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import QuickLayoutBridge

@QuickLayout
final class BodyCreationTestView: UIView {

  var bodyCounter = 0

  @Invalidating(.layout)
  var frameSize = CGSize.zero

  var body: any Layout {
    countedLayout()
  }

  func countedLayout() -> any Layout {
    bodyCounter += 1
    return VStack {
      EmptyLayout()
        .frame(width: frameSize.width, height: frameSize.height)
    }
  }
}
