/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

struct QuickLayoutVariableIdentity: Equatable {
  enum Scope: Equatable {
    case instance, type
  }

  let scope: Scope
  let name: String
  let returnType: String

  init(scope: Scope, name: String, returnType: String) {
    self.scope = scope
    self.name = name
    self.returnType = normalize(type: returnType)
  }
}
