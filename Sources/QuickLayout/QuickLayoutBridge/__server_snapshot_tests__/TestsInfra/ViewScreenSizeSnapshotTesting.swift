/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import FBServerSnapshotTestCase
import UIKit

enum ScreenSize {

  /// iPhone SE, 375x667
  case iPhoneSmall

  /// iPhone 12, 12 Pro, 390x844
  case iPhoneMedium

  /// iPhone 12 Pro Max, 428x926
  case iPhoneLarge

  case custom(size: CGSize)

  var size: CGSize {
    switch self {
    case .iPhoneSmall:
      return CGSize(width: 375.0, height: 667.0)
    case .iPhoneMedium:
      return CGSize(width: 390.0, height: 844.0)
    case .iPhoneLarge:
      return CGSize(width: 428.0, height: 926.0)
    case .custom(let size):
      return size
    }
  }

  var identifier: String {
    switch self {
    case .iPhoneSmall:
      return "iPhoneSmall"
    case .iPhoneMedium:
      return "iPhoneMedium"
    case .iPhoneLarge:
      return "iPhoneLarge"
    case .custom(let size):
      return "Custom_w_\(size.width)_h_\(size.height)"
    }
  }
}

enum SizingStrategy {
  case assign
  case measureVerticalIntrinsicSize(clampWithScreenSize: Bool)

  func makeIdentifier() -> String {
    switch self {
    case .assign: return "SizingStrategy_Assign"
    case .measureVerticalIntrinsicSize(let clampWithScreenSize):
      if clampWithScreenSize {
        return "SizingStrategy_MeasureVerticalIntrinsicSizeWithClampingToScreenSize"
      } else {
        return "SizingStrategy_MeasureVerticalIntrinsicSize"
      }
    }
  }
}

struct SnapshotConfiguration {
  let screenSizes: [ScreenSize]
  let preferredContentSizeCategories: [UIContentSizeCategory]
  let sizingStrategy: [SizingStrategy]
}

struct FlatSnapshotConfiguration {
  let screenSize: ScreenSize
  let preferredContentSizeCategory: UIContentSizeCategory
  let sizingStrategy: SizingStrategy

  func makeIdentifier() -> String {
    return "iPhone_Portrait_Orientation_ScreenSize_" + screenSize.identifier + "_" + makeIdentifierFor(contentSizeCategory: preferredContentSizeCategory) + "_" + sizingStrategy.makeIdentifier()
  }
}

func makeMultipleViewSnapshot<T: UIView>(
  viewFactory: (UIContentSizeCategory) -> T,
  configuration: SnapshotConfiguration
) {

  let flatConfigurations = configuration.screenSizes.flatMap { screenSize in
    configuration.preferredContentSizeCategories.flatMap { contentSizeCategory in
      configuration.sizingStrategy.map { sizingStrategy in
        return FlatSnapshotConfiguration(
          screenSize: screenSize,
          preferredContentSizeCategory: contentSizeCategory,
          sizingStrategy: sizingStrategy
        )
      }
    }
  }

  flatConfigurations.forEach { flatConfiguration in
    makeSingleViewSnapshot(viewFactory: viewFactory, flatConfiguration: flatConfiguration)
  }
}

func makeSingleViewSnapshot<T: UIView>(
  viewFactory: (UIContentSizeCategory) -> T,
  flatConfiguration: FlatSnapshotConfiguration
) {
  let screenSize = flatConfiguration.screenSize
  let contentSizeCategory = flatConfiguration.preferredContentSizeCategory
  let sizingStrategy = flatConfiguration.sizingStrategy
  let identifier = flatConfiguration.makeIdentifier()

  let viewUnderTest = viewFactory(contentSizeCategory)
  switch sizingStrategy {
  case .assign:
    viewUnderTest.frame = CGRect(origin: .zero, size: screenSize.size)
  case .measureVerticalIntrinsicSize(let clampWithScreenSize):
    let intrinsicSize = viewUnderTest.sizeThatFits(CGSize(width: screenSize.size.width, height: .infinity))
    let viewSize = CGSize(width: screenSize.size.width, height: clampWithScreenSize ? min(intrinsicSize.height, screenSize.size.height) : intrinsicSize.height)
    viewUnderTest.frame = CGRect(origin: .zero, size: viewSize)
  }

  viewUnderTest.setNeedsLayout()
  viewUnderTest.layoutIfNeeded()

  if Bundle.main.bundleIdentifier == "com.meta.internal.uipreview" {
    // let snapshotImage = FBRecordSnapshotWithView(viewUnderTest, true) ?? UIImage()
    // let imageView = UIImageView(image: snapshotImage)
    // imageView.backgroundColor = viewUnderTest.backgroundColor
    // imageView.frame = CGRect(origin: .zero, size: snapshotImage.size)
    // imageView.contentMode = .scaleAspectFit

    let scrollView = UIScrollView()
    scrollView.alwaysBounceVertical = true
    scrollView.alwaysBounceHorizontal = true
    scrollView.contentSize = viewUnderTest.frame.size
    scrollView.addSubview(viewUnderTest)
    FBTakeSnapshotOfViewAfterScreenUpdates(scrollView, "Quickly_MultipleViewTests_" + identifier)
  } else {
    FBTakeSnapshotOfViewAfterScreenUpdates(viewUnderTest, "Quickly_MultipleViewTests_" + identifier)
  }
}

private func makeIdentifierFor(contentSizeCategory: UIContentSizeCategory) -> String {
  switch contentSizeCategory {
  case .unspecified: return "UIContentSizeCategory_Unspecified"
  case .extraSmall: return "UIContentSizeCategory_ExtraSmall"
  case .small: return "UIContentSizeCategory_Small"
  case .medium: return "UIContentSizeCategory_Medium"
  case .large: return "UIContentSizeCategory_Large"
  case .extraLarge: return "UIContentSizeCategory_ExtraLarge"
  case .extraExtraLarge: return "UIContentSizeCategory_ExtraExtraLarge"
  case .extraExtraExtraLarge: return "UIContentSizeCategory_ExtraExtraExtraLarge"
  case .accessibilityMedium: return "UIContentSizeCategory_AccessibilityMedium"
  case .accessibilityLarge: return "UIContentSizeCategory_AccessibilityLarge"
  case .accessibilityExtraLarge: return "UIContentSizeCategory_AccessibilityExtraLarge"
  case .accessibilityExtraExtraLarge: return "UIContentSizeCategory_AccessibilityExtraExtraLarge"
  case .accessibilityExtraExtraExtraLarge: return "UIContentSizeCategory_AccessibilityExtraExtraExtraLarge"
  default: return "UIContentSizeCategory_Unknown"
  }
}
