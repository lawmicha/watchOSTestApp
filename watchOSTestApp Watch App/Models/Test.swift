// swiftlint:disable all
import Amplify
import Foundation

public struct Test: Model {
  public let id: String
  public var test: String?
  public var userID: String
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      test: String? = nil,
      userID: String) {
    self.init(id: id,
      test: test,
      userID: userID,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      test: String? = nil,
      userID: String,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.test = test
      self.userID = userID
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}