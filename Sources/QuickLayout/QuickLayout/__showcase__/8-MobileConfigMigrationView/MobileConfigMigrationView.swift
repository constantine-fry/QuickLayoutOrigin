/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import QuickLayout

@MainActor
@QuickLayout
final class MobileConfigMigrationView: UIView {

  private var isBodyEnabledFeatureFlag = false

  private lazy var bodyEnabledLabel = {
    let label = UILabel()
    label.text = "Body is enabled ✅"
    label.textAlignment = .center
    return label
  }()

  private lazy var explainerLabel = {
    let label = UILabel()
    label.text = "Enable body by toggling the switch below."
    label.numberOfLines = 0
    label.textColor = .secondaryLabel
    label.textAlignment = .center
    return label
  }()

  private lazy var bodyEnabledButton = {
    let bodySwitch = UISwitch()
    bodySwitch.addTarget(self, action: #selector(self.switchToggled), for: .valueChanged)
    bodySwitch.sizeToFit()
    return bodySwitch
  }()

  var body: Layout {
    VStack {
      bodyEnabledLabel
      Spacer(10)
      explainerLabel
      Spacer(10)
      bodyEnabledButton
    }
  }

  override var isBodyEnabled: Bool {
    isBodyEnabledFeatureFlag
  }

  override func sizeThatFits(_ size: CGSize) -> CGSize {
    if isBodyEnabled {
      return body.sizeThatFits(size)
    } else {
      // Calculate size in the imperative way.
      return size
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    if !isBodyEnabled {
      imperativeLayout()
    }
  }

  private func imperativeLayout() {
    addSubview(explainerLabel)
    addSubview(bodyEnabledButton)
    let labelSize = explainerLabel.sizeThatFits(self.bounds.size)
    explainerLabel.bounds = CGRect(origin: .zero, size: labelSize)
    explainerLabel.center = CGPoint(x: bounds.midX, y: bounds.midY - 4)
    bodyEnabledButton.center = CGPoint(x: bounds.midX, y: explainerLabel.frame.maxY + 10 + bodyEnabledButton.bounds.height / 2)
  }

  @objc private func switchToggled() {
    isBodyEnabledFeatureFlag.toggle()
    setNeedsLayout()
  }
}

// MARK: Preview code

@available(iOS 17, *)
#Preview {
  MobileConfigMigrationView()
}
