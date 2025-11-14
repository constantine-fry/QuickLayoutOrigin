/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import FBServerSnapshotTestCase
import FBTestImageGenerator
import QuickLayoutBridge

final class VFlowServerSnapShotTests: FBServerSnapshotTestCase {

  func buildVFlowSingleChild(
    itemAlignment: HorizontalAlignment,
    lineAlignment: VerticalAlignment,
    itemSpacing: CGFloat,
    lineSpacing: CGFloat
  ) {

    let view = ColorView(ColorPallete.red, text: "1")

    let VFlow = VFlow(itemAlignment: itemAlignment, lineAlignment: lineAlignment, itemSpacing: itemSpacing, lineSpacing: lineSpacing) {
      view
    }
    takeSnapshot(
      with: VFlow,
      in: .proposed(CGSize(width: 300, height: 300))
    )
  }

  func buildVFlowSingleFixedChild(
    itemAlignment: HorizontalAlignment,
    lineAlignment: VerticalAlignment,
    itemSpacing: CGFloat,
    lineSpacing: CGFloat
  ) {

    let view = ColorView(ColorPallete.red, text: "1")

    let VFlow = VFlow(itemAlignment: itemAlignment, lineAlignment: lineAlignment, itemSpacing: itemSpacing, lineSpacing: lineSpacing) {
      view.frame(width: 100, height: 100)
    }

    takeSnapshot(
      with: VFlow,
      in: .proposed(CGSize(width: 300, height: 300))
    )
  }

  func buildVflowMultipleChildrenSameSizeSingleLine(
    itemAlignment: HorizontalAlignment, lineAlignment: VerticalAlignment,
    itemSpacing: CGFloat,
    lineSpacing: CGFloat,
    layoutDirection: LayoutDirection = .leftToRight
  ) {

    let view1 = ColorView(ColorPallete.red, text: "1")
    let view2 = ColorView(ColorPallete.orange, text: "2")
    let view3 = ColorView(ColorPallete.blue, text: "3")

    let VFlow = VFlow(itemAlignment: itemAlignment, lineAlignment: lineAlignment, itemSpacing: itemSpacing, lineSpacing: lineSpacing) {
      view1
        .frame(width: 50, height: 50)
      view2
        .frame(width: 50, height: 50)
      view3
        .frame(width: 50, height: 50)

    }
    .layoutDirection(layoutDirection)

    takeSnapshot(
      with: VFlow,
      in: .proposed(CGSize(width: 150, height: 150)),
      layoutDirection: layoutDirection
    )

  }

  func buildVflowMultipleChildrenDifferentSizeSingleLine(
    itemAlignment: HorizontalAlignment, lineAlignment: VerticalAlignment,
    itemSpacing: CGFloat,
    lineSpacing: CGFloat,
    layoutDirection: LayoutDirection = .leftToRight
  ) {

    let view1 = ColorView(ColorPallete.red, text: "1")
    let view2 = ColorView(ColorPallete.orange, text: "2")
    let view3 = ColorView(ColorPallete.blue, text: "3")

    let VFlow = VFlow(itemAlignment: itemAlignment, lineAlignment: lineAlignment, itemSpacing: itemSpacing, lineSpacing: lineSpacing) {
      view1
        .frame(width: 60, height: 50)
      view2
        .frame(width: 40, height: 70)
      view3
        .frame(width: 50, height: 40)

    }
    .layoutDirection(layoutDirection)

    takeSnapshot(
      with: VFlow,
      in: .proposed(CGSize(width: 150, height: 150)),
      layoutDirection: layoutDirection
    )

  }

  func buildVflowMultipleChildrenSameSizeMultiLine(
    itemAlignment: HorizontalAlignment, lineAlignment: VerticalAlignment,
    itemSpacing: CGFloat,
    lineSpacing: CGFloat,
    layoutDirection: LayoutDirection = .leftToRight
  ) {

    let view1 = ColorView(ColorPallete.red, text: "1")
    let view2 = ColorView(ColorPallete.orange, text: "2")
    let view3 = ColorView(ColorPallete.blue, text: "3")
    let view4 = ColorView(ColorPallete.yellow, text: "4")
    let view5 = ColorView(.green, text: "5")

    let VFlow = VFlow(itemAlignment: itemAlignment, lineAlignment: lineAlignment, itemSpacing: itemSpacing, lineSpacing: lineSpacing) {
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
      with: VFlow,
      in: .proposed(CGSize(width: 150, height: 150)),
      layoutDirection: layoutDirection
    )

  }

  func buildVflowMultipleChildrenDifferentSizeMultiLine(
    itemAlignment: HorizontalAlignment, lineAlignment: VerticalAlignment,
    itemSpacing: CGFloat,
    lineSpacing: CGFloat,
    layoutDirection: LayoutDirection = .leftToRight
  ) {

    let view1 = ColorView(ColorPallete.red, text: "1")
    let view2 = ColorView(ColorPallete.orange, text: "2")
    let view3 = ColorView(ColorPallete.blue, text: "3")
    let view4 = ColorView(ColorPallete.yellow, text: "4")
    let view5 = ColorView(.green, text: "5")

    let VFlow = VFlow(itemAlignment: itemAlignment, lineAlignment: lineAlignment, itemSpacing: itemSpacing, lineSpacing: lineSpacing) {
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
    .layoutDirection(layoutDirection)

    takeSnapshot(
      with: VFlow,
      in: .proposed(CGSize(width: 150, height: 150)),
      layoutDirection: layoutDirection
    )

  }

  // MARK: - Single Child
  func testSingleChild() {
    buildVFlowSingleChild(
      itemAlignment: .center,
      lineAlignment: .center,
      itemSpacing: 0,
      lineSpacing: 0)
  }

  func testSingleFixedChild() {
    buildVFlowSingleFixedChild(
      itemAlignment: .center,
      lineAlignment: .center,
      itemSpacing: 0,
      lineSpacing: 0)
  }

  // MARK: - Multiple Children Same Size Single Line

  func testMultipleChildrenSameSizeSingleLine() {
    buildVflowMultipleChildrenSameSizeSingleLine(
      itemAlignment: .center,
      lineAlignment: .center,
      itemSpacing: 0,
      lineSpacing: 0)
  }

  func testMultipleChildrenSameSizeSingleLineItemSpacing() {
    buildVflowMultipleChildrenSameSizeSingleLine(
      itemAlignment: .center,
      lineAlignment: .center,
      itemSpacing: 10,
      lineSpacing: 0)
  }

  func testMultipleChildrenSameSizeSingleLineLineSpacing() {
    buildVflowMultipleChildrenSameSizeSingleLine(
      itemAlignment: .center,
      lineAlignment: .center,
      itemSpacing: 0,
      lineSpacing: 10)
  }

  func testMultipleChildrenSameSizeSingleLineItemAndLineSpacing() {
    buildVflowMultipleChildrenSameSizeSingleLine(
      itemAlignment: .center,
      lineAlignment: .center,
      itemSpacing: 10,
      lineSpacing: 15
    )
  }

  // Mark - Multiple Children Different Size Single Line

  func testMultipleChildrenDifferentSizeSingleLine() {
    buildVflowMultipleChildrenDifferentSizeSingleLine(
      itemAlignment: .center,
      lineAlignment: .center,
      itemSpacing: 0,
      lineSpacing: 0)
  }

  func testMultipleChildrenDifferentSizeSingleLineItemAlignmentLeading() {
    buildVflowMultipleChildrenDifferentSizeSingleLine(
      itemAlignment: .leading,
      lineAlignment: .center,
      itemSpacing: 0,
      lineSpacing: 0)
  }

  func testMultipleChildrenDifferentSizeSingleLineItemAlignmentTrailing() {
    buildVflowMultipleChildrenDifferentSizeSingleLine(
      itemAlignment: .trailing,
      lineAlignment: .center,
      itemSpacing: 0,
      lineSpacing: 0)
  }

  func testMultipleChildrenDifferentSizeSingleLineAlignmentTop() {
    buildVflowMultipleChildrenDifferentSizeSingleLine(
      itemAlignment: .center,
      lineAlignment: .top,
      itemSpacing: 0,
      lineSpacing: 0
    )
  }

  func testMultipleChildrenDifferentSizeSingleLineAlignmentBottom() {
    buildVflowMultipleChildrenDifferentSizeSingleLine(
      itemAlignment: .center,
      lineAlignment: .bottom,
      itemSpacing: 0,
      lineSpacing: 0
    )
  }

  func testMultipleChildrenDifferentSizeSingleLineItemSpacing() {
    buildVflowMultipleChildrenDifferentSizeSingleLine(
      itemAlignment: .center,
      lineAlignment: .center,
      itemSpacing: 10,
      lineSpacing: 0)
  }

  func testMultipleChildrenDifferentSizeSingleLineLineSpacing() {
    buildVflowMultipleChildrenDifferentSizeSingleLine(
      itemAlignment: .center,
      lineAlignment: .center,
      itemSpacing: 0,
      lineSpacing: 10)
  }

  func testMultipleChildrenDifferentSizeSingleLineItemAndLineSpacing() {
    buildVflowMultipleChildrenDifferentSizeSingleLine(
      itemAlignment: .center,
      lineAlignment: .center,
      itemSpacing: 10,
      lineSpacing: 15
    )
  }

  // Mark - Multiple Children Same Size Multi Line

  func testMultipleChildrenSameSizeMultiLine() {
    buildVflowMultipleChildrenSameSizeMultiLine(
      itemAlignment: .center,
      lineAlignment: .center,
      itemSpacing: 0,
      lineSpacing: 0)
  }

  func testMultipleChildrenSameSizeMultiLineItemAlignmentLeading() {
    buildVflowMultipleChildrenSameSizeMultiLine(
      itemAlignment: .leading,
      lineAlignment: .center,
      itemSpacing: 0,
      lineSpacing: 0)
  }

  func testMultipleChildrenSameSizeMultiLineItemAlignmentTrailing() {
    buildVflowMultipleChildrenSameSizeMultiLine(
      itemAlignment: .trailing,
      lineAlignment: .center,
      itemSpacing: 0,
      lineSpacing: 0)
  }

  func testMultipleChildrenSameSizeMultiLineItemSpacing() {
    buildVflowMultipleChildrenSameSizeMultiLine(
      itemAlignment: .center,
      lineAlignment: .center,
      itemSpacing: 10,
      lineSpacing: 0)
  }

  func testMultipleChildrenSameSizeMultiLineLineSpacing() {
    buildVflowMultipleChildrenSameSizeMultiLine(
      itemAlignment: .center,
      lineAlignment: .center,
      itemSpacing: 0,
      lineSpacing: 10)
  }

  func testMultipleChildrenSameSizeMultiLineItemAndLineSpacing() {
    buildVflowMultipleChildrenSameSizeMultiLine(
      itemAlignment: .center,
      lineAlignment: .center,
      itemSpacing: 10,
      lineSpacing: 15
    )
  }

  // Mark - Multiple Children Different Size Multi Line

  func testMultipleChildrenDifferentSizeMultiLine() {
    buildVflowMultipleChildrenDifferentSizeMultiLine(
      itemAlignment: .center,
      lineAlignment: .center,
      itemSpacing: 0,
      lineSpacing: 0)
  }

  func testMultipleChildrenDifferentSizeMultiLineItemAlignmentLeading() {
    buildVflowMultipleChildrenDifferentSizeMultiLine(
      itemAlignment: .leading,
      lineAlignment: .center,
      itemSpacing: 0,
      lineSpacing: 0)
  }

  func testMultipleChildrenDifferentSizeMultiLineItemAlignmentTrailing() {
    buildVflowMultipleChildrenDifferentSizeMultiLine(
      itemAlignment: .trailing,
      lineAlignment: .center,
      itemSpacing: 0,
      lineSpacing: 0)
  }

  func testMultipleChildrenDifferentSizeMultiLineAlignmentTop() {
    buildVflowMultipleChildrenDifferentSizeMultiLine(
      itemAlignment: .center,
      lineAlignment: .top,
      itemSpacing: 0,
      lineSpacing: 0
    )
  }

  func testMultipleChildrenDifferentSizeMultiLineAlignmentBottom() {
    buildVflowMultipleChildrenDifferentSizeMultiLine(
      itemAlignment: .center,
      lineAlignment: .top,
      itemSpacing: 0,
      lineSpacing: 0
    )
  }

  func testMultipleChildrenDifferentSizeMultiLineItemSpacing() {
    buildVflowMultipleChildrenDifferentSizeMultiLine(
      itemAlignment: .center,
      lineAlignment: .center,
      itemSpacing: 10,
      lineSpacing: 0)
  }

  func testMultipleChildrenDifferentSizeMultiLineLineSpacing() {
    buildVflowMultipleChildrenDifferentSizeMultiLine(
      itemAlignment: .center,
      lineAlignment: .center,
      itemSpacing: 0,
      lineSpacing: 10)
  }

  func testMultipleChildrenDifferentSizeMultiLineItemAndLineSpacing() {
    buildVflowMultipleChildrenDifferentSizeMultiLine(
      itemAlignment: .center,
      lineAlignment: .center,
      itemSpacing: 10,
      lineSpacing: 15
    )
  }

  //Mark - RTL

  func testMultipleChildrenItemAlignmentLeadingRTL() {
    buildVflowMultipleChildrenSameSizeMultiLine(
      itemAlignment: .leading,
      lineAlignment: .center,
      itemSpacing: 0,
      lineSpacing: 0,
      layoutDirection: .rightToLeft
    )
  }

  func testMultipleChildrenItemAlignmentTrailingRTL() {
    buildVflowMultipleChildrenSameSizeMultiLine(
      itemAlignment: .trailing,
      lineAlignment: .center,
      itemSpacing: 0,
      lineSpacing: 0,
      layoutDirection: .rightToLeft
    )
  }
}
