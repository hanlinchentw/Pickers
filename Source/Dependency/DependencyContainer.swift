//
//  DependencyContainer.swift
//  Picker
//
//  Created by 陳翰霖 on 2023/8/27.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import Foundation
import Swinject

// swiftlint:disable fatal_error
final class DependencyContainer {
  static let shared = DependencyContainer()

  let container = Container()

  func registerAllComponents() {
    container.register(HttpClient.self) { _ in
      HttpClient()
    }

    container.register(RestClient.self) { resolver in
      RestClient(httpClient: resolver.resolve(HttpClient.self)!)
    }
    registerPlaceModelContainer()
  }

  func getService<T>() -> T {
    guard let unwrapService = container.resolve(T.self) else {
      fatalError("Cannot resolve service of type \(T.self)")
    }
    return unwrapService
  }

  func getService<Service>(argument: some Any) -> Service {
    guard let service = container.resolve(Service.self, argument: argument) else {
      fatalError("Cannot resolve service of type \(Service.self)")
    }
    return service
  }
}

// swiftlint:enable fatal_error
