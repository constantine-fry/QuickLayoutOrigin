/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import FBServerSnapshotTestCase
import FBTestImageGenerator
import QuickLayoutBridge

final class HFlowServerSnapShotTests: FBServerSnapshotTestCase {

  func buildHFlowSingleChild(
    itemAlignment: VerticalAlignment,
    lineAlignment: HorizontalAlignment,
    itemSpacing: CGFloat,
    lineSpacing: CGFloat
  ) {

    let view = ColorView(ColorPallete.red, text: "1")

    let HFlow = HFlow(itemAlignment: itemAlignment, lineAlignment: lineAlignment, itemSpacing: itemSpacing, lineSpacing: lineSpacing) {
      view
    }

    takeSnapshot(
      with: HFlow,
      in: .proposed(CGSize(width: 300, height: 300))
    )
  }

  func buildHFlowSingleFixedChild(
    itemAlignment: VerticalAlignment,
    lineAlignment: HorizontalAlignment,
    itemSpacing: CGFloat,
    lineSpacing: CGFloat
  ) {

    let view = ColorView(ColorPallete.red, text: "1")

    let HFlow = HFlow(itemAlignment: itemAlignment, lineAlignment: lineAlignment, itemSpacing: itemSpacing, lineSpacing: lineSpacing) {
      view.frame(width: 100, height: 100)
    }

    takeSnapshot(
      with: HFlow,
      in: .proposed(CGSize(width: 300, height: 300))
    )
  }

  func buildHflowMultipleChildrenSameSizeMultiLine(
    itemAlignment: VerticalAlignment, lineAlignment: HorizontalAlignment,
    itemSpacing: CGFloat,
    lineSpacing: CGFloat,
    layoutDirection: LayoutDirection = .leftToRight
  ) {

    let view1 = ColorView(ColorPallete.red, text: "1")
    let view2 = ColorView(ColorPallete.orange, text: "2")
    let view3 = ColorView(ColorPallete.blue, text: "3")
    let view4 = ColorView(ColorPallete.yellow, text: "4")
    let view5 = ColorView(.green, text: "5")

    let HFlow = HFlow(itemAlignment: itemAlignment, lineAlignment: lineAlignment, itemSpacing: itemSpacing, lineSpacing: lineSpacing) {
      view1
        .frame(width: 50, height: 50)
      view2
        .frame(width: 50, height: 50)
      view3
        .frame(width: 50, height: 50)
      view4
        .frame(width: 50, height: 50)
      view5
        .frame(width: 50, height: 50)
    }
    .layoutDirection(layoutDirection)

    takeSnapshot(
      with: HFlow,
      in: .proposed(CGSize(width: 150, height: 150))
    )

  }

  func buildHflowMultipleChildrenSameSizeSingleLine(
    itemAlignment: VerticalAlignment,
    lineAlignment: HorizontalAlignment,
    itemSpacing: CGFloat,
    lineSpacing: CGFloat,
    proposedSize: CGSize = CGSize(width: 200, height: 200)
  ) {

    let view1 = ColorView(ColorPallete.red, text: "1")
    let view2 = ColorView(ColorPallete.orange, text: "2")
    let view3 = ColorView(ColorPallete.blue, text: "3")

    let HFlow = HFlow(itemAlignment: itemAlignment, lineAlignment: lineAlignment, itemSpacing: itemSpacing, lineSpacing: lineSpacing) {
      view1
        .frame(width: 50, height: 50)
      view2
        .frame(width: 50, height: 50)
      view3
        .frame(width: 50, height: 50)

    }

    takeSnapshot(
      with: HFlow,
      in: .proposed(proposedSize)
    )

  }

  func buildHflowMultipleChildrenDifferentSizeSingleLine(
    itemAlignment: VerticalAlignment,
    lineAlignment: HorizontalAlignment,
    itemSpacing: CGFloat,
    lineSpacing: CGFloat
  ) {

    let view1 = ColorView(ColorPallete.red, text: "1")
    let view2 = ColorView(ColorPallete.orange, text: "2")
    let view3 = ColorView(ColorPallete.blue, text: "3")

    let HFlow = HFlow(itemAlignment: itemAlignment, lineAlignment: lineAlignment, itemSpacing: itemSpacing, lineSpacing: lineSpacing) {
      view1
        .frame(width: 80, height: 50)
      view2
        .frame(width: 30, height: 70)
      view3
        .frame(width: 50, height: 40)
    }

    takeSnapshot(
      with: HFlow,
      in: .proposed(CGSize(width: 200, height: 200))
    )

  }

  func buildHflowMultipleChildrenDifferentSizeMultiLine(
    itemAlignment: VerticalAlignment,
    lineAlignment: HorizontalAlignment,
    itemSpacing: CGFloat,
    lineSpacing: CGFloat
  ) {

    let view1 = ColorView(ColorPallete.red, text: "1")
    let view2 = ColorView(ColorPallete.orange, text: "2")
    let view3 = ColorView(ColorPallete.blue, text: "3")
    let view4 = ColorView(ColorPallete.yellow, text: "4")
    let view5 = ColorView(.green, text: "5")

    let HFlow = HFlow(itemAlignment: itemAlignment, lineAlignment: lineAlignment, itemSpacing: itemSpacing, lineSpacing: lineSpacing) {
      view1
        .frame(width: 80, height: 50)
      view2
        .frame(width: 30, height: 70)
      view3
        .frame(width: 50, height: 40)
      view4
        .frame(width: 50, height: 50)
      view5
        .frame(width: 50, height: 50)
    }

    takeSnapshot(
      with: HFlow,
      in: .proposed(CGSize(width: 200, height: 200))
    )

  }

  // MARK: - Single Child
  func testSingleChild() {
    buildHFlowSingleChild(
      itemAlignment: .center,
      lineAlignment: .center,
      itemSpacing: 0,
      lineSpacing: 0)
  }

  // MARK: - Multiple Children Same Size Single Line

  func testMultipleChildrenSameSizeSingleLine() {
    buildHflowMultipleChildrenSameSizeSingleLine(
      itemAlignment: .center,
      lineAlignment: .center,
      itemSpacing: 0,
      lineSpacing: 0)
  }

  func testMultipleChildrenSameSizeSingleLineItemAlignmentTop() {
    buildHflowMultipleChildrenSameSizeSingleLine(
      itemAlignment: .top,
      lineAlignment: .center,
      itemSpacing: 0,
      lineSpacing: 0)
  }

  func testMultipleChildrenSameSizeSingleLineItemAlignmentBottom() {
    buildHflowMultipleChildrenSameSizeSingleLine(
      itemAlignment: .bottom,
      lineAlignment: .center,
      itemSpacing: 0,
      lineSpacing: 0)
  }

  func testMultipleChildrenSameSizeSingleLineItemSpacing() {
    buildHflowMultipleChildrenSameSizeSingleLine(
      itemAlignment: .center,
      lineAlignment: .center,
      itemSpacing: 10,
      lineSpacing: 0)
  }

  func testMultipleChildrenSameSizeSingleLineLineSpacing() {
    buildHflowMultipleChildrenSameSizeSingleLine(
      itemAlignment: .center,
      lineAlignment: .center,
      itemSpacing: 0,
      lineSpacing: 10)
  }

  func testMultipleChildrenSameSizeSingleLineItemAndLineSpacing() {
    buildHflowMultipleChildrenSameSizeSingleLine(
      itemAlignment: .center,
      lineAlignment: .center,
      itemSpacing: 10,
      lineSpacing: 15
    )
  }

  // MARK: - Multiple Children with different proposed size
  func testMultipleChildrenSameSizeSingleLine150x150() {
    buildHflowMultipleChildrenSameSizeSingleLine(
      itemAlignment: .center,
      lineAlignment: .center,
      itemSpacing: 0,
      lineSpacing: 0,
      proposedSize: CGSize(width: 150, height: 150)
    )
  }

  func testMultipleChildrenSameSizeSingleLine149x150() {
    buildHflowMultipleChildrenSameSizeSingleLine(
      itemAlignment: .center,
      lineAlignment: .center,
      itemSpacing: 0,
      lineSpacing: 0,
      proposedSize: CGSize(width: 149, height: 150)
    )
  }

  func testMultipleChildrenSameSizeSingleLine99x150() {
    buildHflowMultipleChildrenSameSizeSingleLine(
      itemAlignment: .center,
      lineAlignment: .center,
      itemSpacing: 0,
      lineSpacing: 0,
      proposedSize: CGSize(width: 99, height: 150)
    )
  }

  func testMultipleChildrenSameSizeSingleLine49x150() {
    buildHflowMultipleChildrenSameSizeSingleLine(
      itemAlignment: .center,
      lineAlignment: .center,
      itemSpacing: 0,
      lineSpacing: 0,
      proposedSize: CGSize(width: 49, height: 150)
    )
  }

  func testMultipleChildrenSameSizeSingleLine170x150WithItemSpacing() {
    buildHflowMultipleChildrenSameSizeSingleLine(
      itemAlignment: .center,
      lineAlignment: .center,
      itemSpacing: 10,
      lineSpacing: 0,
      proposedSize: CGSize(width: 170, height: 150)
    )
  }

  func testMultipleChildrenSameSizeSingleLine169x150WithItemSpacing() {
    buildHflowMultipleChildrenSameSizeSingleLine(
      itemAlignment: .center,
      lineAlignment: .center,
      itemSpacing: 10,
      lineSpacing: 0,
      proposedSize: CGSize(width: 169, height: 150)
    )
  }

  func testMultipleChildrenSameSizeSingleLine110x150WithItemSpacing() {
    buildHflowMultipleChildrenSameSizeSingleLine(
      itemAlignment: .center,
      lineAlignment: .center,
      itemSpacing: 10,
      lineSpacing: 0,
      proposedSize: CGSize(width: 110, height: 150)
    )
  }

  func testMultipleChildrenSameSizeSingleLine109x150WithItemSpacing() {
    buildHflowMultipleChildrenSameSizeSingleLine(
      itemAlignment: .center,
      lineAlignment: .center,
      itemSpacing: 10,
      lineSpacing: 0,
      proposedSize: CGSize(width: 109, height: 150)
    )
  }

  // MARK: - Multiple Children Same Size MultiLine

  func testMultipleChildren() {
    buildHflowMultipleChildrenSameSizeMultiLine(
      itemAlignment: .center,
      lineAlignment: .center,
      itemSpacing: 0,
      lineSpacing: 0
    )
  }

  func testMultipleChildrenItemAlignmentTop() {
    buildHflowMultipleChildrenSameSizeMultiLine(
      itemAlignment: .top,
      lineAlignment: .center, itemSpacing: 0,
      lineSpacing: 0
    )
  }

  func testMultipleChildrenItemAlignmentBottom() {
    buildHflowMultipleChildrenSameSizeMultiLine(
      itemAlignment: .bottom,
      lineAlignment: .center, itemSpacing: 0,
      lineSpacing: 0
    )
  }

  func testMultipleChildrenLineAlignmentLeading() {
    buildHflowMultipleChildrenSameSizeMultiLine(
      itemAlignment: .center,
      lineAlignment: .leading, itemSpacing: 0,
      lineSpacing: 0
    )
  }

  func testMultipleChildrenLineAlignmentTrailing() {
    buildHflowMultipleChildrenSameSizeMultiLine(
      itemAlignment: .center,
      lineAlignment: .trailing,
      itemSpacing: 0,
      lineSpacing: 0
    )
  }

  func testMultipleChildrenItemAlignmentTopLineAlignmentLeading() {
    buildHflowMultipleChildrenSameSizeMultiLine(
      itemAlignment: .top,
      lineAlignment: .leading,
      itemSpacing: 0,
      lineSpacing: 0
    )
  }

  func testMultipleChildrenItemAlignmentTopLineAlingmentTrailing() {
    buildHflowMultipleChildrenSameSizeMultiLine(
      itemAlignment: .top,
      lineAlignment: .trailing,
      itemSpacing: 0,
      lineSpacing: 0
    )
  }

  func testMultipleChildrenItemAlignmentBottomLineAlignmentLeading() {
    buildHflowMultipleChildrenSameSizeMultiLine(
      itemAlignment: .bottom,
      lineAlignment: .leading,
      itemSpacing: 0,
      lineSpacing: 0
    )
  }

  func testMultipleChildrenItemAlignmentBottomLineAlignmentTrailing() {
    buildHflowMultipleChildrenSameSizeMultiLine(
      itemAlignment: .bottom,
      lineAlignment: .trailing,
      itemSpacing: 0,
      lineSpacing: 0
    )
  }

  func testMultipleChildrenWithItemSpacing() {
    buildHflowMultipleChildrenSameSizeMultiLine(
      itemAlignment: .center,
      lineAlignment: .center,
      itemSpacing: 10,
      lineSpacing: 0
    )
  }

  func testMultipleChildrenWithLineSpacing() {
    buildHflowMultipleChildrenSameSizeMultiLine(
      itemAlignment: .center,
      lineAlignment: .center,
      itemSpacing: 0,
      lineSpacing: 10
    )
  }

  func testMultipleChildrenWithItemAndLineSpacing() {
    buildHflowMultipleChildrenSameSizeMultiLine(
      itemAlignment: .center,
      lineAlignment: .center,
      itemSpacing: 10,
      lineSpacing: 15
    )
  }

  func testMultipleChildrenWithNegativeItemSpacing() {
    buildHflowMultipleChildrenSameSizeMultiLine(
      itemAlignment: .center,
      lineAlignment: .center,
      itemSpacing: -10,
      lineSpacing: 0
    )
  }

  func testMultipleChildrenWithNegativeLineSpacing() {
    buildHflowMultipleChildrenSameSizeMultiLine(
      itemAlignment: .center,
      lineAlignment: .center,
      itemSpacing: 0,
      lineSpacing: -10
    )
  }

  // MARK: - Multiple Children Different Size Single Line

  func testMultipleChildrenDifferentSizeSingleLine() {
    buildHflowMultipleChildrenDifferentSizeSingleLine(
      itemAlignment: .center,
      lineAlignment: .center,
      itemSpacing: 0,
      lineSpacing: 0
    )
  }

  func testMultipleChildrenDifferentSizeSingleLineItemAlignmentTop() {
    buildHflowMultipleChildrenDifferentSizeSingleLine(
      itemAlignment: .top,
      lineAlignment: .center,
      itemSpacing: 0,
      lineSpacing: 0
    )
  }

  func testMultipleChildrenDifferentSizeSingleLineItemAlignmentBottom() {
    buildHflowMultipleChildrenDifferentSizeSingleLine(
      itemAlignment: .bottom,
      lineAlignment: .center,
      itemSpacing: 0,
      lineSpacing: 0
    )
  }

  func testMultipleChildrenDifferentSizeSingleLineLineAlignmentLeading() {
    buildHflowMultipleChildrenDifferentSizeSingleLine(
      itemAlignment: .center,
      lineAlignment: .leading,
      itemSpacing: 0,
      lineSpacing: 0
    )
  }

  func testMultipleChildrenDifferentSizeSingleLineLineAlignmentTrailing() {
    buildHflowMultipleChildrenDifferentSizeSingleLine(
      itemAlignment: .center,
      lineAlignment: .trailing,
      itemSpacing: 0,
      lineSpacing: 0
    )
  }

  func testMultipleChildrenDifferentSizeSingleLineItemAlignmentTopLineAlignmentLeading() {
    buildHflowMultipleChildrenDifferentSizeSingleLine(
      itemAlignment: .top,
      lineAlignment: .leading,
      itemSpacing: 0,
      lineSpacing: 0
    )
  }

  func testMultipleChildrenDifferentSizeSingleLineItemAlignmentTopLineAlignmentTrailing() {
    buildHflowMultipleChildrenDifferentSizeSingleLine(
      itemAlignment: .top,
      lineAlignment: .trailing,
      itemSpacing: 0,
      lineSpacing: 0
    )
  }

  func testMultipleChildrenDifferentSizeSingleLineItemAlignmentBottomLineAlignmentLeading() {
    buildHflowMultipleChildrenDifferentSizeSingleLine(
      itemAlignment: .bottom,
      lineAlignment: .leading,
      itemSpacing: 0,
      lineSpacing: 0
    )
  }

  func testMultipleChildrenDifferentSizeSingleLineItemAlignmentBottomLineAlignmentTrailing() {
    buildHflowMultipleChildrenDifferentSizeSingleLine(
      itemAlignment: .bottom,
      lineAlignment: .trailing,
      itemSpacing: 0,
      lineSpacing: 0
    )
  }

  func testMultipleChildrenDifferentSizeWithItemSpacing() {
    buildHflowMultipleChildrenDifferentSizeSingleLine(
      itemAlignment: .center,
      lineAlignment: .center,
      itemSpacing: 10,
      lineSpacing: 0
    )
  }

  func testMultipleChildrenDifferentSizeWithLineSpacing() {
    buildHflowMultipleChildrenDifferentSizeSingleLine(
      itemAlignment: .center,
      lineAlignment: .center,
      itemSpacing: 0,
      lineSpacing: 10
    )
  }

  func testMultipleChildrenDifferentSizeWithItemAndLineSpacing() {
    buildHflowMultipleChildrenDifferentSizeSingleLine(
      itemAlignment: .center,
      lineAlignment: .center,
      itemSpacing: 10,
      lineSpacing: 15
    )
  }

  // MARK: - Multiple Children Different Size MultiLine

  func testMultipleChildrenDifferentSizeMultiLine() {
    buildHflowMultipleChildrenDifferentSizeMultiLine(
      itemAlignment: .center,
      lineAlignment: .center,
      itemSpacing: 0,
      lineSpacing: 0
    )
  }

  func testMultipleChildrenDifferentSizeMultiLineItemAlignmentTop() {
    buildHflowMultipleChildrenDifferentSizeMultiLine(
      itemAlignment: .top,
      lineAlignment: .center,
      itemSpacing: 0,
      lineSpacing: 0
    )
  }

  func testMultipleChildrenDifferentSizeMultiLineItemAlignmentBottom() {
    buildHflowMultipleChildrenDifferentSizeMultiLine(
      itemAlignment: .bottom,
      lineAlignment: .center,
      itemSpacing: 0,
      lineSpacing: 0
    )
  }

  func testMultipleChildrenDifferentSizeMultiLineLineAlignmentLeading() {
    buildHflowMultipleChildrenDifferentSizeMultiLine(
      itemAlignment: .center,
      lineAlignment: .leading,
      itemSpacing: 0,
      lineSpacing: 0
    )
  }

  func testMultipleChildrenDifferentSizeMultiLineLineAlignmentTrailing() {
    buildHflowMultipleChildrenDifferentSizeMultiLine(
      itemAlignment: .center,
      lineAlignment: .trailing,
      itemSpacing: 0,
      lineSpacing: 0
    )
  }

  func testMultipleChildrenDifferentSizeMultiLineItemAlignmentTopLineAlignmentLeading() {
    buildHflowMultipleChildrenDifferentSizeMultiLine(
      itemAlignment: .top,
      lineAlignment: .leading,
      itemSpacing: 0,
      lineSpacing: 0
    )
  }

  func testMultipleChildrenDifferentSizeMultiLineItemAlignmentTopLineAlignmentTrailing() {
    buildHflowMultipleChildrenDifferentSizeMultiLine(
      itemAlignment: .top,
      lineAlignment: .trailing,
      itemSpacing: 0,
      lineSpacing: 0
    )
  }

  func testMultipleChildrenDifferentSizeMultiLineItemAlignmentBottomLineAlignmentLeading() {
    buildHflowMultipleChildrenDifferentSizeMultiLine(
      itemAlignment: .bottom,
      lineAlignment: .leading,
      itemSpacing: 0,
      lineSpacing: 0
    )
  }

  func testMultipleChildrenDifferentSizeMultiLineItemAlignmentBottomLineAlignmentTrailing() {
    buildHflowMultipleChildrenDifferentSizeMultiLine(
      itemAlignment: .bottom,
      lineAlignment: .trailing,
      itemSpacing: 0,
      lineSpacing: 0
    )
  }

  func testMultipleChildrenDifferentSizeMultiLineWithItemSpacing() {
    buildHflowMultipleChildrenDifferentSizeMultiLine(
      itemAlignment: .center,
      lineAlignment: .center,
      itemSpacing: 10,
      lineSpacing: 0
    )
  }

  func testMultipleChildrenDifferentSizeMultiLineWithLineSpacing() {
    buildHflowMultipleChildrenDifferentSizeMultiLine(
      itemAlignment: .center,
      lineAlignment: .center,
      itemSpacing: 0,
      lineSpacing: 10
    )
  }

  func testMultipleChildrenDifferentSizeMultiLineWithItemAndLineSpacing() {
    buildHflowMultipleChildrenDifferentSizeMultiLine(
      itemAlignment: .center,
      lineAlignment: .center,
      itemSpacing: 10,
      lineSpacing: 15
    )
  }

  func testMultipleChildrenDifferentSizeMultiLineWithNegativeItemSpacing() {
    buildHflowMultipleChildrenDifferentSizeMultiLine(
      itemAlignment: .center,
      lineAlignment: .center,
      itemSpacing: -10,
      lineSpacing: 0
    )
  }

  func testMultipleChildrenDifferentSizeMultiLineWithNegativeLineSpacing() {
    buildHflowMultipleChildrenDifferentSizeMultiLine(
      itemAlignment: .center,
      lineAlignment: .center,
      itemSpacing: 0,
      lineSpacing: -10
    )
  }

  // MARK: - RTL

  func testMultipleChildrenRTL() {
    buildHflowMultipleChildrenSameSizeMultiLine(
      itemAlignment: .center,
      lineAlignment: .center,
      itemSpacing: 0,
      lineSpacing: 0,
      layoutDirection: .rightToLeft
    )
  }

  func testMultipleChildrenLineAlignmentLeadingRTL() {
    buildHflowMultipleChildrenSameSizeMultiLine(
      itemAlignment: .center,
      lineAlignment: .leading,
      itemSpacing: 0,
      lineSpacing: 0,
      layoutDirection: .rightToLeft
    )
  }

  func testMultipleChildrenLineAlignmentTrailingRTL() {
    buildHflowMultipleChildrenSameSizeMultiLine(
      itemAlignment: .center,
      lineAlignment: .trailing,
      itemSpacing: 0,
      lineSpacing: 0,
      layoutDirection: .rightToLeft)
  }
}
