/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import QuickLayout

private extension VerticalAlignment {

  private enum ArrowAlignment: AlignmentID {
    static func defaultValue(in d: ViewDimensions) -> CGFloat {
      /// The value here doesn't matter, as the ArrowAlignment is used just as identifier for alignmentGuides.
      return 0
    }
  }

  static let arrowAlignment = VerticalAlignment(ArrowAlignment.self)
}

private extension HorizontalAlignment {

  private enum ListAlignment: AlignmentID {
    static func defaultValue(in d: ViewDimensions) -> CGFloat {
      /// The value here doesn't matter, as the ListAlignment is used just as identifier for alignmentGuides.
      return 0
    }
  }

  static let listAlignment = HorizontalAlignment(ListAlignment.self)
}

@QuickLayout
final class FruitSelectorView: UIView {

  private let iconView = UIImageView(image: UIImage(systemName: "arrow.right.circle.fill")!) // swiftlint:disable:this force_unwrapping
  private let labels: [UILabel]
  private var selectedLabel: UILabel

  init() {
    let words = ["Mango", "Strawberries", "Pineapple", "Watermelon", "Orange", "Apple", "Blueberries"]

    self.labels = words.map { word in
      let label = UILabel()
      label.text = word
      label.textAlignment = .center
      label.font = UIFont.preferredFont(forTextStyle: .title2)
      return label
    }

    selectedLabel = labels[1]
    super.init(frame: .zero)
    self.labels.forEach { label in
      let gr = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
      label.isUserInteractionEnabled = true
      label.addGestureRecognizer(gr)
    }
  }

  @objc
  func didTap(_ sender: UITapGestureRecognizer) {
    let label = sender.view
    if let label = self.labels.first(where: { $0 === label }) {
      selectedLabel = label
      UIView.animate(withDuration: 0.33, delay: 0.0, options: .curveEaseInOut) {
        self.setNeedsLayout()
        self.layoutIfNeeded()
      }
    }
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  var body: Layout {

    /// Using .arrowAlignment here makes HStack align the arrow icon with the center of the selected label.
    HStack(alignment: .arrowAlignment, spacing: 10) {

      iconView
        .alignmentGuide(.arrowAlignment) { d in
          /// Define .arrowAlignment as the center of the icon.
          d[VerticalAlignment.center]
        }

      VStack(alignment: .leading, spacing: 8) {
        ForEach(labels) { label in
          if label === selectedLabel {
            label
              .alignmentGuide(.arrowAlignment) { d in
                /// Define .arrowAlignment as the center the selected label.
                d[VerticalAlignment.center]
              }
          } else {
            label
          }
        }
      }
      .alignmentGuide(.listAlignment) { d in
        /// Define .listAlignment as the horizontal center of the list.
        /// This is to exclude the size of the iconView.
        d[HorizontalAlignment.center]
      }
    }
    .padding(16)
    .alignmentGuide(HorizontalAlignment.center) { d in
      /// Override HorizontalAlignment.center with .listAlignment
      /// from the child VStack. This is to make the view container view align the list of labels in the center without including the size of the iconView.
      d[.listAlignment]
    }
  }
}

@available(iOS 17, *)
#Preview {
  FruitSelectorView()
}
