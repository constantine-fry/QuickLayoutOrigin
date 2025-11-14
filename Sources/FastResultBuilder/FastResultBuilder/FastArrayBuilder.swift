/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation

/*
 * A resultBuilder that builds an array of the given generic type (the results).
 */
@resultBuilder
public struct FastArrayBuilder<T> {
  public static func buildBlock(_ expressions: any FastExpression...) -> BlockExpression {
    BlockExpression(expressions: expressions)
  }

  public static func buildBlock(_ expressions: [any FastExpression]) -> BlockExpression {
    BlockExpression(expressions: expressions)
  }

  public static func buildExpression(_ value: T) -> ValueExpression<T> {
    ValueExpression<T>(value: value)
  }

  public static func buildExpression(_ value: T?) -> any FastExpression {
    if let value {
      ValueExpression(value: value)
    } else {
      NothingExpression()
    }
  }

  public static func buildExpression(_ expression: FastExpression) -> any FastExpression {
    expression
  }

  public static func buildOptional(_ block: BlockExpression?) -> any FastExpression {
    block ?? NothingExpression()
  }

  public static func buildEither(first block: BlockExpression) -> BlockExpression {
    block
  }

  public static func buildEither(second block: BlockExpression) -> BlockExpression {
    block
  }

  public static func buildArray(_ elements: [FastExpression]) -> ArrayExpression {
    ArrayExpression(elements: elements)
  }

  public static func buildFinalResult(_ block: BlockExpression) -> [T] {
    ResultsExpressionVisitor<T>.getResults(block: block)
  }
}
