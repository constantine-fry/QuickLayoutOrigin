/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftSyntax
import SwiftSyntaxMacros

enum QuickLayoutInjectionError: Error {
  case failedToParseInjectionArgument
  case unsupportedExpressionStringInput

  var localizedDescription: String {
    switch self {
    case .failedToParseInjectionArgument:
      return "Failed to parse injection argument"
    case .unsupportedExpressionStringInput:
      return "Interpolated strings with expression input are not supported"
    }
  }
}

public struct QuickLayoutInjection: BodyMacro {
  static public func expansion(
    of node: AttributeSyntax,
    providingBodyFor declaration: some DeclSyntaxProtocol & WithOptionalCodeBlockSyntax,
    in context: some MacroExpansionContext
  ) throws -> [CodeBlockItemSyntax] {
    // Extract the argument from @_QuickLayoutInjection(<argument>)
    guard let argument = node.arguments?.as(LabeledExprListSyntax.self)?.first?.expression.as(StringLiteralExprSyntax.self) else {
      throw QuickLayoutInjectionError.failedToParseInjectionArgument
    }
    // Map this to a string value
    let argumentValue = try argument.segments.compactMap { segment -> String? in
      switch segment {
      case .stringSegment(let content):
        return content.content.text
      case .expressionSegment:
        throw QuickLayoutInjectionError.unsupportedExpressionStringInput
      }
    }.joined()
    let injectedSyntax = CodeBlockItemSyntax(stringLiteral: "\(argumentValue)")
    guard let statements = declaration.body?.statements, let function = declaration.function else {
      return [injectedSyntax]
    }
    var modifiedStatements = [CodeBlockItemSyntax]()
    var hasPerformedInjection = false
    // Step through each statement, injecting the argument directly after the
    // call to super.<functionSignature>. By performing the injection at this
    // point, it becomes similar in behavior to an invisible superclass. Functions
    // with injection applied can do work before or after the injection, and in
    // general the expectations line up with what engineers might expect.
    for statement in statements {
      modifiedStatements.append(statement)
      if !hasPerformedInjection && statement.description.trimmingWhitespaceAndNewlines == function.defaultSuperCall {
        modifiedStatements.append(injectedSyntax)
        hasPerformedInjection = true
      }
    }
    if !hasPerformedInjection {
      modifiedStatements.append(injectedSyntax)
    }
    return modifiedStatements
  }
}
