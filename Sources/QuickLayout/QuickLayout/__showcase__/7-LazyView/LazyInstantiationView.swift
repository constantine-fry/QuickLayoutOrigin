/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import QuickLayout

@MainActor
@QuickLayout
final class LazyInstantiationView: UIView {

  private let firstLabel = LazyView {
    let label = UILabel()
    label.text = "One"
    label.textColor = .systemOrange
    label.font = .systemFont(ofSize: 20, weight: .bold)
    return label
  }

  private let secondLabel = LazyView {
    let label = UILabel()
    label.text = "Two"
    label.textColor = .systemGreen
    label.font = .systemFont(ofSize: 20, weight: .bold)
    return label
  }

  private let thirdLabel = LazyView {
    let label = UILabel()
    label.text = "Three"
    label.textColor = .systemIndigo
    label.font = .systemFont(ofSize: 20, weight: .bold)
    return label
  }

  private let addLabelButton = LazyView {
    let button = UIButton(type: .system)
    button.setTitle("Add", for: .normal)
    return button
  }

  private let removeLabelButton = LazyView {
    let button = UIButton(type: .system)
    button.setTitleColor(.systemRed, for: .normal)
    button.setTitleColor(.systemGray, for: .disabled)
    button.setTitle("Remove", for: .normal)
    return button
  }

  private let descriptionLabel = LazyView {
    let label = UILabel()
    label.numberOfLines = 0
    label.textAlignment = .center
    return label
  }

  private var numberOfLabels = 0

  override init(frame: CGRect) {
    super.init(frame: frame)
    addLabelButton.loadIfNeeded().addTarget(self, action: #selector(addLabel), for: .touchUpInside)
    removeLabelButton.loadIfNeeded().addTarget(self, action: #selector(removeLabel), for: .touchUpInside)
    updateState()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  var body: Layout {
    VStack(spacing: 16) {
      HStack(spacing: 8) {
        if numberOfLabels > 0 {
          firstLabel
        }
        if numberOfLabels > 1 {
          secondLabel
        }
        if numberOfLabels > 2 {
          thirdLabel
        }
      }
      HStack(spacing: 8) {
        removeLabelButton
        addLabelButton
      }
      descriptionLabel
    }
  }

  @objc private func addLabel() {
    updateNumberOfLabels(to: numberOfLabels + 1)
  }

  @objc private func removeLabel() {
    updateNumberOfLabels(to: numberOfLabels - 1)
  }

  private func updateNumberOfLabels(to value: Int) {
    numberOfLabels = value
    setNeedsLayout()
    layoutIfNeeded()
    updateState()
  }

  private func updateState() {
    addLabelButton.loadIfNeeded().isEnabled = numberOfLabels < 3
    removeLabelButton.loadIfNeeded().isEnabled = numberOfLabels > 0
    let description = """
      First loaded: \(firstLabel.isLoaded ? "✅" : "❌")
      Second loaded: \(secondLabel.isLoaded ? "✅" : "❌")
      Third loaded: \(thirdLabel.isLoaded ? "✅" : "❌")
      """
    let attribtuedString = NSMutableAttributedString(string: description)
    let style = NSMutableParagraphStyle()
    style.lineSpacing = 12
    attribtuedString.addAttribute(.paragraphStyle, value: style, range: .init(location: 0, length: description.count))
    descriptionLabel.loadIfNeeded().attributedText = attribtuedString
  }
}

// MARK: Preview code

@available(iOS 17, *)
#Preview {
  LazyInstantiationView()
}
