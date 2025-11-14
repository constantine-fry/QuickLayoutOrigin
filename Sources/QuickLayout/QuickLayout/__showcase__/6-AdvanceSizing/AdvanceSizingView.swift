/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import QuickLayout

@QuickLayout
final class AdvanceSizingView: UIView {

  private let label = UILabel()
  private let imageView = UIImageView()
  private let separator = UIView()

  init(with text: String, image: UIImage?) {
    label.text = text
    imageView.image = image
    separator.backgroundColor = .gray
    separator.layer.cornerRadius = 1
    super.init(frame: .zero)
  }

  override convenience init(frame: CGRect) {
    self.init(with: "This is an example view", image: UIImage(systemName: "lightbulb"))
  }

  @MainActor required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  var body: Layout {
    VStack(spacing: 5) {
      HStack(spacing: 8) {
        label
        imageView
      }
      separator
        .frame(height: 2)
        .frame(maxWidth: 220)
    }
  }

  // MARK: - Advance Sizing

  static func sizeThatFits(_ size: CGSize, with text: String, image: UIImage?) -> CGSize {
    VStack(spacing: 5) {
      HStack(spacing: 8) {
        UILabel.proxy(for: text)
        UIImageView.proxy(for: image)
      }
      ViewProxy(width: 220, height: 2)
    }
    .sizeThatFits(size)
  }
}

// MARK: Preview code

@available(iOS 17, *)
#Preview {
  AdvanceSizingView(with: "This is an example view", image: UIImage(systemName: "lightbulb"))
}
