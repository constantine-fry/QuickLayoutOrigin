/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation

public protocol FastExpression {
  func apply(visitor: inout some ExpressionVisitor)
}

public struct ValueExpression<ValueType>: FastExpression {
  public let value: ValueType

  public init(value: ValueType) {
    self.value = value
  }

  public func apply(visitor: inout some ExpressionVisitor) {
    visitor.visit(value: self)
  }
}

public struct NothingExpression: FastExpression {
  public init() {}

  public func apply(visitor: inout some ExpressionVisitor) {
    visitor.visit(nothing: self)
  }
}

public struct BlockExpression: FastExpression {
  let expressions: [FastExpression]

  public init(expressions: [FastExpression]) {
    self.expressions = expressions
  }

  public func apply(visitor: inout some ExpressionVisitor) {
    visitor.visit(block: self)
  }
}

public struct ArrayExpression: FastExpression {
  let elements: [FastExpression]

  public init(elements: [FastExpression]) {
    self.elements = elements
  }

  public func apply(visitor: inout some ExpressionVisitor) {
    visitor.visit(array: self)
  }
}
