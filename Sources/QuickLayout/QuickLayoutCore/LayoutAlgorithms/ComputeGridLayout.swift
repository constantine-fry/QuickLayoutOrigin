/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation

private struct GridItem {
  let horizontalFlexibility: Flexibility
  let verticalFlexibility: Flexibility
  let layoutPriority: CGFloat
}

func computeGridLayout(rows: [GridRowElement], alignment: Alignment, proposedSize: CGSize, verticalSpacing: CGFloat, horizontalSpacing: CGFloat) -> LayoutNode {
  let rowCount = rows.count
  let columnCount = rows.reduce(0) { max($0, $1.children.count) }

  if rowCount == 0 || (rowCount == 1 && columnCount == 0) {
    return LayoutNode(view: nil, size: .zero, children: [], alignmentGuides: AlignmentGuidesResolver.none())
  }

  return LayoutContext.$latestMainAxis.withValue(.horizontal) {
    if rowCount == 1 && columnCount == 1 {
      let childLayout = rows[0].children[0].quick_layoutThatFits(proposedSize)
      let childNode = LayoutNode.Child(position: .zero, layout: childLayout)
      return LayoutNode(view: nil, size: childLayout.size, children: [childNode], alignmentGuides: AlignmentGuidesResolver.extract(childNode))
    }

    let availableSize = CGSize(
      width: max(0, proposedSize.width - (CGFloat(columnCount - 1) * horizontalSpacing)),
      height: max(0, proposedSize.height - (CGFloat(rowCount - 1) * verticalSpacing))
    )

    // Step 1: Build metadata for each cell.
    let gridItems = buildGridItems(
      rows: rows,
      rowCount: rowCount,
      columnCount: columnCount
    )

    // Step 2: Calculate the layout of each cell.
    let cellLayouts = layoutCellsContent(
      in: availableSize,
      rows: rows,
      gridItems: gridItems,
      rowCount: rowCount,
      columnCount: columnCount
    )

    let columnAlignments = extractColumnAlignments(from: cellLayouts, columnCount: columnCount)
    let rowAlignments = extractRowAlignments(from: rows, rowCount: rowCount)

    // Step 3: Position content within their own cell.
    let positionedChildren = positionContentInCells(
      layouts: cellLayouts,
      alignment: alignment,
      columnAlignments: columnAlignments,
      rowAlignments: rowAlignments,
      verticalSpacing: verticalSpacing,
      horizontalSpacing: horizontalSpacing,
      rowCount: rowCount,
      columnCount: columnCount
    )
    return positionedChildren
  }
}

@inline(__always)
private func buildGridItems(rows: [GridRowElement], rowCount: Int, columnCount: Int) -> [[GridItem]] {
  let emptyItem = GridItem(
    horizontalFlexibility: .fixedSize,
    verticalFlexibility: .fixedSize,
    layoutPriority: -CGFloat.infinity
  )
  var gridItems: [[GridItem]] = []
  gridItems.reserveCapacity(rowCount)
  for row in rows {
    var rowItems: [GridItem] = []
    rowItems.reserveCapacity(columnCount)
    for child in row.children {
      let item = GridItem(
        horizontalFlexibility: child.quick_flexibility(for: .horizontal),
        verticalFlexibility: child.quick_flexibility(for: .vertical),
        layoutPriority: child.quick_layoutPriority()
      )
      rowItems.append(item)
    }
    while rowItems.count < columnCount {
      rowItems.append(emptyItem)
    }
    gridItems.append(rowItems)
  }
  return gridItems
}

@inline(__always)
private func layoutCellsContent(
  in availableSize: CGSize,
  rows: [GridRowElement],
  gridItems: [[GridItem]],
  rowCount: Int,
  columnCount: Int
) -> [[LayoutNode?]] {
  var cellLayouts: [[LayoutNode?]] = Array(repeating: Array(repeating: nil, count: columnCount), count: rowCount)
  var lastProposedSizes: [[CGSize?]] = Array(repeating: Array(repeating: nil, count: columnCount), count: rowCount)
  var minColumnWidths: [CGFloat] = Array(repeating: 0, count: columnCount)
  var minRowHeights: [CGFloat] = Array(repeating: 0, count: rowCount)
  var maxColumnWidths: [CGFloat] = Array(repeating: 0, count: columnCount)
  var maxRowHeights: [CGFloat] = Array(repeating: 0, count: rowCount)
  var maxColumnLayoutPriority: [CGFloat] = Array(repeating: -.infinity, count: columnCount)
  var maxRowLayoutPriority: [CGFloat] = Array(repeating: -.infinity, count: rowCount)
  var maxColumnFlexibility: [Flexibility] = Array(repeating: .fixedSize, count: columnCount)
  var maxRowFlexibility: [Flexibility] = Array(repeating: .fixedSize, count: rowCount)

  for (rowIndex, row) in rows.enumerated() {
    for (columnIndex, child) in row.children.enumerated() {
      let item = gridItems[rowIndex][columnIndex]
      maxColumnLayoutPriority[columnIndex] = max(maxColumnLayoutPriority[columnIndex], item.layoutPriority)
      maxRowLayoutPriority[rowIndex] = max(maxRowLayoutPriority[rowIndex], item.layoutPriority)
      maxColumnFlexibility[columnIndex] = max(maxColumnFlexibility[columnIndex], item.horizontalFlexibility)
      maxRowFlexibility[rowIndex] = max(maxRowFlexibility[rowIndex], item.verticalFlexibility)

      if item.horizontalFlexibility == .fullyFlexible && item.verticalFlexibility == .fullyFlexible {
        maxColumnWidths[columnIndex] = .infinity
        maxRowHeights[rowIndex] = .infinity
        continue
      }
      let layout = child.quick_layoutThatFits(availableSize)
      cellLayouts[rowIndex][columnIndex] = layout
      lastProposedSizes[rowIndex][columnIndex] = availableSize

      let width = item.horizontalFlexibility == .fullyFlexible ? .infinity : layout.size.width
      let height = item.verticalFlexibility == .fullyFlexible ? .infinity : layout.size.height
      maxColumnWidths[columnIndex] = max(maxColumnWidths[columnIndex], width)
      maxRowHeights[rowIndex] = max(maxRowHeights[rowIndex], height)

      if item.horizontalFlexibility == .fixedSize {
        minColumnWidths[columnIndex] = max(minColumnWidths[columnIndex], width)
      }
      if item.verticalFlexibility == .fixedSize {
        minRowHeights[rowIndex] = max(minRowHeights[rowIndex], height)
      }
    }
  }

  var availableSize = availableSize

  for columnIndex in 0..<columnCount {
    if maxColumnFlexibility[columnIndex] == .fixedSize {
      availableSize.width -= maxColumnWidths[columnIndex]
    }
  }

  for rowIndex in 0..<rowCount {
    if maxRowFlexibility[rowIndex] == .fixedSize {
      availableSize.height -= maxRowHeights[rowIndex]
    }
  }

  maxRowHeights = Array(repeating: 0, count: rowCount)
  var availableWidth = availableSize.width
  let groupedColumnIndices = groupByLayoutPriority(maxColumnLayoutPriority)
  for key in groupedColumnIndices.keys.sorted(by: >) {
    if let columnIndices = groupedColumnIndices[key] {
      let columnIndices = columnIndices.sorted {
        maxColumnWidths[$0] < maxColumnWidths[$1]
      }
      var count = columnIndices.count + 1
      for columnIndex in columnIndices {
        count -= 1
        if maxColumnFlexibility[columnIndex] == .fixedSize { continue }

        var columnWidth = 0.0
        for rowIndex in 0..<rowCount {
          guard columnIndex < rows[rowIndex].children.count else { continue }
          let proposedSize = CGSize(
            width: max(minColumnWidths[columnIndex], availableWidth / CGFloat(count)),
            height: max(minRowHeights[rowIndex], availableSize.height)
          )

          let child = rows[rowIndex].children[columnIndex]
          let layout = cellLayouts[rowIndex][columnIndex]
          let lastProposedSize = lastProposedSizes[rowIndex][columnIndex]
          if layout == nil {
            cellLayouts[rowIndex][columnIndex] = child.quick_layoutThatFits(proposedSize)
            lastProposedSizes[rowIndex][columnIndex] = proposedSize
          } else if let layout, !canReuseLayout(lastProposedSize: lastProposedSize, proposedSize: proposedSize, lastLayout: layout) {
            cellLayouts[rowIndex][columnIndex] = child.quick_layoutThatFits(proposedSize)
            lastProposedSizes[rowIndex][columnIndex] = proposedSize
          }
          if let layout = cellLayouts[rowIndex][columnIndex] {
            if maxColumnFlexibility[columnIndex] != .fixedSize {
              columnWidth = max(columnWidth, layout.size.width)
            }
            let item = gridItems[rowIndex][columnIndex]
            let height = item.verticalFlexibility == .fullyFlexible ? .infinity : layout.size.height
            maxRowHeights[rowIndex] = max(maxRowHeights[rowIndex], height)
          }
        }
        availableWidth = max(0, availableWidth - columnWidth)
      }
    }
  }

  var columnSizes: [CGFloat] = Array(repeating: 0, count: columnCount)
  for rowIndex in 0..<rowCount {
    for columnIndex in 0..<columnCount {
      if let layout = cellLayouts[rowIndex][columnIndex] {
        columnSizes[columnIndex] = max(columnSizes[columnIndex], layout.size.width)
      }
    }
  }

  var availableHeight = availableSize.height
  let groupedRowIndices = groupByLayoutPriority(maxRowLayoutPriority)
  for key in groupedRowIndices.keys.sorted(by: >) {
    if let rowIndices = groupedRowIndices[key] {
      let rowIndices = rowIndices.sorted {
        maxRowHeights[$0] < maxRowHeights[$1]
      }
      var count = rowIndices.count + 1
      var rowHeight = 0.0
      for rowIndex in rowIndices {
        count -= 1

        for columnIndex in 0..<columnCount {
          guard columnIndex < rows[rowIndex].children.count else { break }

          let proposedSize = CGSize(
            width: max(minColumnWidths[columnIndex], columnSizes[columnIndex]),
            height: max(minRowHeights[rowIndex], availableHeight / CGFloat(count))
          )
          let child = rows[rowIndex].children[columnIndex]
          let layout = cellLayouts[rowIndex][columnIndex]
          let lastProposedSize = lastProposedSizes[rowIndex][columnIndex]
          if layout == nil {
            cellLayouts[rowIndex][columnIndex] = child.quick_layoutThatFits(proposedSize)
          } else if let layout, !canReuseLayout(lastProposedSize: lastProposedSize, proposedSize: proposedSize, lastLayout: layout) {
            cellLayouts[rowIndex][columnIndex] = child.quick_layoutThatFits(proposedSize)
          }
          if let layout = cellLayouts[rowIndex][columnIndex] {
            if maxColumnFlexibility[columnIndex] != .fixedSize {
              rowHeight = max(rowHeight, layout.size.height)
            }
          }
        }
        availableHeight = max(0, availableHeight - rowHeight)
      }
    }
  }

  return cellLayouts
}

private func groupByLayoutPriority(_ maxLayoutPriority: [CGFloat]) -> [CGFloat: [Int]] {
  var result = [CGFloat: [Int]]()
  for (index, priority) in maxLayoutPriority.enumerated() {
    result[priority, default: []].append(index)
  }
  return result
}

private func find<T>(in layoutNode: LayoutNode, valueBlock: (GridInfo) -> T?) -> T? {
  if let gridInfo = layoutNode.gridInfo, let value = valueBlock(gridInfo) {
    return value
  }
  if let child = layoutNode.children.first, layoutNode.children.count == 1 {
    return find(in: child.layout, valueBlock: valueBlock)
  }
  return nil
}

@inline(__always)
private func positionContentInCells(
  layouts: [[LayoutNode?]],
  alignment: Alignment,
  columnAlignments: [HorizontalAlignment?],
  rowAlignments: [VerticalAlignment?],
  verticalSpacing: CGFloat,
  horizontalSpacing: CGFloat,
  rowCount: Int,
  columnCount: Int
) -> LayoutNode {
  let isRTL = LayoutContext.layoutDirection == .rightToLeft
  var rowSizes = Array(repeating: CGFloat(0), count: rowCount)
  var columnSizes = Array(repeating: CGFloat(0), count: columnCount)
  for (rowIndex, rowLayouts) in layouts.enumerated() {
    for (columnIndex, layout) in rowLayouts.enumerated() {
      if let layout {
        rowSizes[rowIndex] = max(rowSizes[rowIndex], layout.size.height)
        columnSizes[columnIndex] = max(columnSizes[columnIndex], layout.size.width)
      }
    }
  }
  var positionedChildren = [LayoutNode.Child]()
  var currentY: CGFloat = 0
  for (rowIndex, rowLayouts) in layouts.enumerated() {
    var currentX: CGFloat = 0
    let rowAlignment = rowAlignments[rowIndex]
    let range = {
      if isRTL {
        stride(from: rowLayouts.count - 1, through: 0, by: -1)
      } else {
        stride(from: 0, through: rowLayouts.count - 1, by: 1)
      }
    }()
    for columnIndex in range {
      if let layout = rowLayouts[columnIndex] {
        let columnAlignmentOverride = columnAlignments[columnIndex]
        let cellSize = CGSize(width: columnSizes[columnIndex], height: rowSizes[rowIndex])
        let dimensions = ElementDimensions(cellSize)
        let xPosition: CGFloat
        let yPosition: CGFloat
        if let unitPoint = find(in: layout, valueBlock: { $0.unitPoint }) {
          let unitPoint = isRTL ? UnitPoint(x: 1 - unitPoint.x, y: unitPoint.y) : unitPoint
          xPosition = (dimensions.width - layout.size.width) * unitPoint.x
          yPosition = (dimensions.height - layout.size.height) * unitPoint.y
        } else {
          let gridCellAnchorAlignment = find(in: layout, valueBlock: { $0.alignment })
          let alignment =
            gridCellAnchorAlignment
            ?? Alignment(
              horizontal: columnAlignmentOverride ?? alignment.horizontal,
              vertical: rowAlignment ?? alignment.vertical
            )
          xPosition = dimensions[alignment.horizontal] - layout.dimensions[alignment.horizontal]
          yPosition = dimensions[alignment.vertical] - layout.dimensions[alignment.vertical]
        }
        let position = CGPoint(x: currentX + xPosition, y: currentY + yPosition)
        positionedChildren.append(LayoutNode.Child(position: roundToPixelGrid(position), layout: layout))
      }
      currentX += columnSizes[columnIndex] + horizontalSpacing
    }
    currentY += rowSizes[rowIndex] + verticalSpacing
  }
  let totalWidth = columnSizes.reduce(0, +) + CGFloat(columnCount - 1) * horizontalSpacing
  let totalHeight = rowSizes.reduce(0, +) + CGFloat(rowCount - 1) * verticalSpacing
  let gridSize = CGSize(width: totalWidth, height: totalHeight)
  return LayoutNode(view: nil, size: gridSize, children: positionedChildren, alignmentGuides: AlignmentGuidesResolver.none())
}

@inline(__always)
private func extractColumnAlignments(from cellLayouts: [[LayoutNode?]], columnCount: Int) -> [HorizontalAlignment?] {
  var columnAlignments: [HorizontalAlignment?] = Array(repeating: nil, count: columnCount)
  for rowLayouts in cellLayouts {
    for (colIndex, layout) in rowLayouts.enumerated() {
      if let layout, let columnAlignment = find(in: layout, valueBlock: { $0.columnAlignment }) {
        columnAlignments[colIndex] = columnAlignment
      }
    }
  }
  return columnAlignments
}

@inline(__always)
private func extractRowAlignments(from rows: [GridRowElement], rowCount: Int) -> [VerticalAlignment?] {
  var rowAlignments: [VerticalAlignment?] = Array(repeating: nil, count: rowCount)
  for rowIndex in 0..<rowCount {
    if let alignment = rows[rowIndex].alignment {
      rowAlignments[rowIndex] = alignment
    }
  }
  return rowAlignments
}

private func canReuseLayout(lastProposedSize: CGSize?, proposedSize: CGSize, lastLayout: LayoutNode) -> Bool {
  return Fuzzy.compare(proposedSize.width, lessThanOrEqual: lastProposedSize?.width ?? .infinity)
    && Fuzzy.compare(proposedSize.height, lessThanOrEqual: lastProposedSize?.height ?? .infinity)
    && Fuzzy.compare(lastLayout.size.width, lessThanOrEqual: proposedSize.width)
    && Fuzzy.compare(lastLayout.size.height, lessThanOrEqual: proposedSize.height)
}
