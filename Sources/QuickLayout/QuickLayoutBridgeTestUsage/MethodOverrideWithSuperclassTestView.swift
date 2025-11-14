/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import QuickLayoutBridge

class BaseView: UIView {
  var baseLayoutSubviewsCounter = 0
  var baseSizeThatFitsCounter = 0

  override func layoutSubviews() {
    baseLayoutSubviewsCounter += 1
    super.layoutSubviews()
  }

  override func sizeThatFits(_ size: CGSize) -> CGSize {
    baseSizeThatFitsCounter += 1
    return CGSize(width: 100, height: 100)
  }
}

@QuickLayout
final class MethodOverrideWithSuperclassTestView: BaseView {

  var bodyCounter = 0
  var layoutSubviewsCounter = 0
  var sizeThatFitsCounter = 0

  @Invalidating(.layout)
  var frameSize = CGSize.zero

  var body: any Layout {
    countedLayout()
  }

  private func countedLayout() -> any Layout {
    bodyCounter += 1
    return VStack {
      EmptyLayout()
        .frame(width: frameSize.width, height: frameSize.height)
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    layoutSubviewsCounter += 1
  }

  override func sizeThatFits(_ size: CGSize) -> CGSize {
    sizeThatFitsCounter += 1
    return super.sizeThatFits(size)
  }
}
