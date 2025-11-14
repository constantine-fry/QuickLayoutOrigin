/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import QuickLayout

private extension VerticalAlignment {

  private struct EmojiTitleAlignment: AlignmentID {
    static func defaultValue(in context: ViewDimensions) -> CGFloat {
      context[VerticalAlignment.bottom]
    }
  }

  static let emojiTitle = VerticalAlignment(
    EmojiTitleAlignment.self
  )
}

@QuickLayout
final class EmojiAlignmentView: UIView {

  private let emojis: [EmojiDisplay]
  private let titleView = UILabel()

  init() {
    self.titleView.text = "Odd one out?"
    self.titleView.font = .systemFont(ofSize: 17, weight: .bold)
    self.emojis = _models.map {
      let emojiView = UILabel()
      emojiView.text = $0.emojiString
      let titleView = UILabel()
      titleView.text = $0.emojiTitle
      let descriptionView: UILabel?
      if let description = $0.emojiDescription {
        descriptionView = UILabel()
        descriptionView?.text = description
        descriptionView?.textColor = .secondaryLabel
        descriptionView?.font = .systemFont(ofSize: 13)
        emojiView.font = .systemFont(ofSize: 40)
      } else {
        descriptionView = nil
      }
      return EmojiDisplay(emojiView: emojiView, emojiTitleView: titleView, emojiDescriptionView: descriptionView)
    }
    super.init(frame: .zero)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  var body: Layout {
    VStack(spacing: 30) {
      titleView
      HStack(alignment: .emojiTitle, spacing: 16) {
        for emojiDisplay in emojis {
          VStack {
            emojiDisplay.emojiView
            emojiDisplay.emojiTitleView
              .alignmentGuide(.emojiTitle) { _ in 0 }
            emojiDisplay.emojiDescriptionView
          }
        }
      }
    }
  }
}

private struct Model {
  let emojiString: String
  let emojiTitle: String
  let emojiDescription: String?
}

private struct EmojiDisplay {
  let emojiView: UIView
  let emojiTitleView: UIView
  let emojiDescriptionView: UIView?
}

private let _models: [Model] = [
  .init(emojiString: "🍔", emojiTitle: "Burger", emojiDescription: nil),
  .init(emojiString: "🍇", emojiTitle: "Grape", emojiDescription: nil),
  .init(emojiString: "🏡", emojiTitle: "House", emojiDescription: "This one!"),
  .init(emojiString: "🍎", emojiTitle: "Apple", emojiDescription: nil),
]

@available(iOS 17, *)
#Preview {
  EmojiAlignmentView()
}
