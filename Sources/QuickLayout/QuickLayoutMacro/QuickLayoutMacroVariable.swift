/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftSyntax

/**
 Defines the variables that the @QuickLayout macro interacts with.
*/
enum QuickLayoutMacroVariable: CaseIterable {

  /**
   Defines how variables are handled.
  */
  enum MemberBehavior {
    case prependLayoutBuilderAttribute
  }

  case body
}

/**
 Defines behavior and attributes for each QuickLayoutMacroVariable case.
*/
extension QuickLayoutMacroVariable {
  var identity: QuickLayoutVariableIdentity {
    switch self {
    case .body:
      .init(scope: .instance, name: "body", returnType: "Layout")
    }
  }

  var memberBehavior: MemberBehavior {
    switch self {
    case .body:
      .prependLayoutBuilderAttribute
    }
  }
}
