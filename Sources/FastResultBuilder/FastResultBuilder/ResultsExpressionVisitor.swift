/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation

public protocol ExpressionVisitor {
  mutating func visit<V>(value: ValueExpression<V>)
  mutating func visit(nothing: NothingExpression)
  mutating func visit(block: BlockExpression)
  mutating func visit(array: ArrayExpression)
}

public struct ResultsExpressionVisitor<T>: ExpressionVisitor {
  var results: [T] = []

  public mutating func visit<V>(value: ValueExpression<V>) {
    // Only interested in values that we can add to the results
    if let value = value.value as? T {
      results.append(value)
    }
  }

  public mutating func visit(array: ArrayExpression) {
    for expression in array.elements {
      visit(any: expression)
    }
  }

  public mutating func visit(nothing: NothingExpression) {
  }

  public mutating func visit(any expression: FastExpression) {
    expression.apply(visitor: &self)
  }

  public mutating func visit(block: BlockExpression) {
    for expression in block.expressions {
      visit(any: expression)
    }
  }

  static func getResults(block: BlockExpression) -> [T] {
    var visitor = ResultsExpressionVisitor<T>()

    visitor.results.reserveCapacity(block.expressions.count)
    visitor.visit(block: block)

    return visitor.results
  }
}
