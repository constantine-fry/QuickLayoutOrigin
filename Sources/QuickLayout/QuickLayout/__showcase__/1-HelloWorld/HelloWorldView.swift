/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import QuickLayout

@QuickLayout
final class HelloWorldView: UIView {

  private let imageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(systemName: "globe.americas")
    return imageView
  }()

  private let titleLabel = {
    let label = UILabel()
    label.text = "Hello World!"
    label.textColor = .label
    return label
  }()

  private let subtitleLabel = {
    let label = UILabel()
    label.text = "This is a simple layout with QuickLayout"
    label.textColor = .secondaryLabel
    return label
  }()

  var body: Layout {
    HStack {
      imageView
      Spacer(8)
      VStack(alignment: .leading) {
        titleLabel
        subtitleLabel
      }
      Spacer()
    }
    .padding(16)
  }
}

// MARK: Preview code

@available(iOS 17, *)
#Preview {
  HelloWorldView()
}
