// swiftlint:disable all
import Amplify
import Foundation

extension Test {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case test
    case userID
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let test = Test.keys
    
    model.authRules = [
      rule(allow: .public, operations: [.create, .update, .delete, .read])
    ]
    
    model.listPluralName = "Tests"
    model.syncPluralName = "Tests"
    
    model.attributes(
      .index(fields: ["userID"], name: "byUser"),
      .primaryKey(fields: [test.id])
    )
    
    model.fields(
      .field(test.id, is: .required, ofType: .string),
      .field(test.test, is: .optional, ofType: .string),
      .field(test.userID, is: .required, ofType: .string),
      .field(test.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(test.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension Test: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}