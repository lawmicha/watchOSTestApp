// swiftlint:disable all
import Amplify
import Foundation

public struct User: Model {
  public let id: String
  public var email: String?
  public var tests: List<Test>?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      email: String? = nil,
      tests: List<Test>? = []) {
    self.init(id: id,
      email: email,
      tests: tests,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      email: String? = nil,
      tests: List<Test>? = [],
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.email = email
      self.tests = tests
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}