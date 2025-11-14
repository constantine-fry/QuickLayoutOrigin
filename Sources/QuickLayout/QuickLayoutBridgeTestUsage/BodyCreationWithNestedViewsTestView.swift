/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import QuickLayoutBridge

final class LeafView: UIView {
  var sizeThatFitsCounter = 0

  @Invalidating(.layout)
  var frameSize = CGSize.zero

  @Invalidating(.layout)
  var property: Int = 0

  override func sizeThatFits(_ size: CGSize) -> CGSize {
    sizeThatFitsCounter += 1
    return frameSize
  }
}

@QuickLayout
final class PrivateChildView: UIView {
  var bodyCounter: Int = 0

  @Invalidating(.layout)
  var property: Int = 0

  let leafView = LeafView()

  var body: any Layout {
    countedLayout()
  }

  private func countedLayout() -> any Layout {
    bodyCounter += 1
    return VStack {
      leafView
    }
  }
}

@QuickLayout
final class BodyCreationWithNestedViewsTestView: UIView {

  var bodyCounter = 0

  let childView1 = PrivateChildView()
  let childView2 = PrivateChildView()

  @Invalidating(.layout)
  var property: Int = 0

  var body: any Layout {
    countedLayout()
  }

  private func countedLayout() -> any Layout {
    bodyCounter += 1
    return HStack {
      VStack {
        childView1
        childView2
      }
    }
  }
}
