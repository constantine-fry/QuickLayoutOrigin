/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

struct QuickLayoutFunctionIdentity: Equatable {
  enum Scope: Equatable {
    case instance, type
  }

  struct Parameter: Equatable {
    let externalName: String?
    let type: String
  }

  let scope: Scope
  let name: String
  let parameters: [Parameter]
  let returnType: String

  init(scope: Scope, name: String, parameters: [(externalName: String?, type: String)], returnType: String) {
    self.scope = scope
    self.name = name
    self.returnType = normalize(type: returnType)
    self.parameters = parameters.map {
      Parameter(externalName: $0.externalName, type: normalize(type: $0.type))
    }
  }
}
