/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import QuickLayout

private let numberColors: [UIColor] = [.systemRed, .systemBlue, .systemGray, .systemPink, .systemTeal, .systemBrown, .systemOrange, .systemYellow, .systemGreen, .systemIndigo]

@MainActor
@QuickLayout
final class UpdatingWithAnimationView: UIView {

  private let numberViews: [UIView] = (1...10).map {
    let label = UILabel()
    label.font = .preferredFont(forTextStyle: .title1)
    label.text = "\($0)"
    label.textColor = .white
    label.layer.cornerRadius = 8
    label.layer.cornerCurve = .continuous
    label.layer.masksToBounds = true
    label.textAlignment = .center
    label.backgroundColor = numberColors[$0 - 1]
    return label
  }

  private lazy var button: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Update with Animations", for: .normal)
    button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    return button
  }()

  var numberViewIsActive = [Bool].init(repeating: false, count: 10)

  var body: Layout {
    VStack {
      HStack(spacing: 8) {
        for (index, numberView) in numberViews.enumerated() {
          if numberViewIsActive[index] {
            numberView
              .expand(by: CGSize(width: 16, height: 8))
          }
        }
      }
      Spacer(20)
      button
    }
  }

  @objc private func buttonTapped() {
    numberViewIsActive = numberViewIsActive.map { _ in Bool.random() }
    setNeedsLayout()
    UIView.animate(withDuration: 0.5, delay: 0, options: [.beginFromCurrentState, .curveEaseInOut]) {
      self.layoutIfNeeded()
    }
  }
}

// MARK: Preview code

@available(iOS 17, *)
#Preview {
  UpdatingWithAnimationView()
}
