/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import QuickLayout

@MainActor
@QuickLayout
final class StateManagementView: UIView {

  private var count = 0
  private let label = UILabel()

  private lazy var button = {
    let button = UIButton(type: .system)
    button.setTitle("Add One", for: .normal)
    button.addTarget(self, action: #selector(addCount), for: .touchUpInside)
    return button
  }()

  private lazy var reset = {
    let button = UIButton(type: .system)
    button.setTitle("Reset", for: .normal)
    button.tintColor = .systemRed
    button.addTarget(self, action: #selector(resetCount), for: .touchUpInside)
    return button
  }()

  var body: Layout {
    VStack(spacing: 8) {
      if count > 0 {
        label
      }
      HStack(spacing: 8) {
        button
        reset
      }
    }
  }

  @objc private func addCount() {
    count += 1
    label.text = "Count: \(count)"
    setNeedsLayout()
  }

  @objc private func resetCount() {
    count = 0
    setNeedsLayout()
  }
}

// MARK: Preview code

@available(iOS 17, *)
#Preview {
  StateManagementView()
}
