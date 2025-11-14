/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import QuickLayout

@QuickLayout
final class AlignmentGuidesView: UIView {

  private let groceriesTitleLabel = {
    let label = UILabel()
    label.text = "Groceries"
    label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
    return label
  }()

  private let groceryItemLabels = ["Milk", "Eggs", "Bananas"].map {
    let label = UILabel()
    label.text = $0
    return label
  }

  private let tasksTitleLabel = {
    let label = UILabel()
    label.text = "Tasks"
    label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
    return label
  }()

  private let taskItemLabels = ["Laundry", "Cook dinner"].map {
    let label = UILabel()
    label.text = $0
    return label
  }

  var body: Layout {
    ///
    ///Note: This is for demonstration purposes only. Prefer using .padding() modifier when the alignmentGuide returns fixed value.
    ///
    VStack(alignment: .leading, spacing: 5) {
      groceriesTitleLabel
      for item in groceryItemLabels {
        item.alignmentGuide(.leading) { _ in -10 }
      }
      Spacer(20)
      tasksTitleLabel
      for item in taskItemLabels {
        item.alignmentGuide(.leading) { _ in -10 }
      }
    }
  }
}

@available(iOS 17, *)
#Preview {
  AlignmentGuidesView()
}
