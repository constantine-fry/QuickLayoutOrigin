/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import QuickLayout

/// Declarative Layout in a UICollectionView based screen.
/// **Key concepts**:
///     - Animations
///     - Dynamic Text support
///     - RTL support for free (edit scheme: https://pxl.cl/5MGDW)
@MainActor
protocol BarCardViewCellDelegate: AnyObject {
  func didTapShareButton(_ cell: BarCardViewCell, bar: BarModel)
}

@QuickLayout
final class BarCardViewCell: UICollectionViewCell {
  static let reuseIdentifier = "BarCardViewCellReuseIdentifier"

  private var expandDescription = false

  private(set) var bar: BarModel?

  weak var delegate: BarCardViewCellDelegate?

  private let blurEffectView = {
    let blurEffect = UIBlurEffect(style: .light)
    let visualEffectView = UIVisualEffectView(effect: blurEffect)
    visualEffectView.layer.masksToBounds = true
    visualEffectView.layer.cornerRadius = 20
    return visualEffectView
  }()

  private let name = {
    let label = UILabel()
    let boldTitle1Font = UIFont(descriptor: UIFont.preferredFont(forTextStyle: .title1).fontDescriptor.withSymbolicTraits(.traitBold) ?? UIFont.preferredFont(forTextStyle: .title1).fontDescriptor, size: 0)
    label.font = boldTitle1Font
    label.textColor = .white
    label.adjustsFontForContentSizeCategory = true
    return label
  }()

  private let locationName = {
    let label = UILabel()
    label.font = UIFont.preferredFont(forTextStyle: .body)
    label.textColor = .white
    label.adjustsFontForContentSizeCategory = true
    return label
  }()

  private lazy var descriptionLabel = {
    let label = UILabel()
    label.adjustsFontForContentSizeCategory = true
    label.numberOfLines = 0
    label.textColor = .white
    label.font = UIFont.preferredFont(forTextStyle: .callout)
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapContentLabel))
    addGestureRecognizer(tapGesture)
    return label
  }()

  private lazy var shareButton = {
    let button = UIButton(type: .system)
    button.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
    button.tintColor = .white
    button.addTarget(self, action: #selector(didTapShareButton), for: .touchUpInside)
    return button
  }()

  private let mediaContent = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()

  override func prepareForReuse() {
    super.prepareForReuse()
    /// Reset the internal state
    expandDescription = false
  }

  // MARK: - Layout

  var body: Layout {
    ZStack(alignment: .bottom) {
      mediaContent.resizable()
      HStack(alignment: .top) {
        VStack(alignment: .leading, spacing: 5) {
          name
          locationName
          Spacer(10)
          descriptionLabel
            .frame(maxHeight: expandDescription ? nil : 50)
        }
        Spacer()
        shareButton
      }
      .padding(15)
      .background { blurEffectView }
      .offset(y: -(window?.safeAreaInsets.bottom ?? 0))
    }
    .padding(.horizontal, 15)
  }

  // MARK: - Setup

  func prepare(with item: BarModel) {
    bar = item
    mediaContent.image = item.coverImage
    name.text = item.name
    locationName.text = item.locationName
    descriptionLabel.text = item.description
  }

  // MARK: - Actions

  @objc func didTapContentLabel() {
    expandDescription.toggle()
    setNeedsLayout()
    descriptionLabel.setNeedsDisplay()
    UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.4, options: []) {
      self.shareButton.alpha = self.expandDescription ? 1.0 : 0.0
      self.layoutIfNeeded()
    }
  }

  @objc func didTapShareButton() {
    guard let bar else { return }
    delegate?.didTapShareButton(self, bar: bar)
  }
}

// MARK: Preview code

@available(iOS 17, *)
#Preview {
  BarsListViewController()
}
