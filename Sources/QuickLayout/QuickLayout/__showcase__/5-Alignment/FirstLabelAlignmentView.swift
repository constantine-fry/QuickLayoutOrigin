/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import QuickLayout

private extension VerticalAlignment {

  private struct TitleCenterAlignment: AlignmentID {
    static func defaultValue(in context: ViewDimensions) -> CGFloat {
      context[VerticalAlignment.center]
    }
  }

  static let titleCenterAlignment = VerticalAlignment(TitleCenterAlignment.self)
}

@QuickLayout
final class FirstLabelAlignmentView: UIView {

  let iconView = UIImageView(image: UIImage(systemName: "face.smiling")!) // swiftlint:disable:this force_unwrapping
  let titleView = UILabel()
  let subtitleLabel = UILabel()

  init() {
    self.titleView.text = "Mauris fringilla ligula felis, nec pharetra velit congue id. Aenean hendrerit arcu lorem, in tempor est posuere id."
    self.titleView.font = UIFont.preferredFont(forTextStyle: .headline)
    self.titleView.numberOfLines = 0

    self.subtitleLabel.text = "Lorem ipsum dolor sit amet consectetur adipiscing elit"
    self.subtitleLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
    self.subtitleLabel.numberOfLines = 0

    self.iconView.layer.borderColor = UIColor.systemGray.cgColor
    self.iconView.layer.borderWidth = 1

    super.init(frame: .zero)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  var body: Layout {
    HStack(alignment: .titleCenterAlignment) {
      iconView
        .resizable()
        .frame(width: 20, height: 20)
        .alignmentGuide(.titleCenterAlignment, computeValue: { d in d[.top] + d.height / 2 })
      Spacer(16)
      VStack(alignment: .leading) {
        titleView
          .alignmentGuide(.titleCenterAlignment, computeValue: { d in d[.top] + d.height / 2 })
        subtitleLabel
      }
      Spacer()
    }
    .padding(16)
  }
}

@available(iOS 17, *)
#Preview {
  FirstLabelAlignmentView()
}
