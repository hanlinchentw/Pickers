//
//  RealmPersistenceManager.swift
//  MyPokemon
//
//  Created by Leo Chen on 2023/2/24.
//

import Foundation
import RealmSwift

protocol RealmPersistenceManagerProtocol {
	func objects<T: Object>(_ type: T.Type, predicate: NSPredicate?) -> Results<T>?
	func object<T: Object>(_ type: T.Type, key: Any) -> T?
	func add<T: Object>(_ data: [T], update: Bool)
	func add<T: Object>(_ data: T, update: Bool)
	func delete<T: Object>(_ data: [T])
	func delete<T: Object>(_ data: T)
}

final class RealmPersistenceManager: RealmPersistenceManagerProtocol {
	static let shared = RealmPersistenceManager()
	
	var testSuite: String?
	
	init(testSuite: String? = nil) {
		self.testSuite = testSuite
	}
	
	func getRealm() -> Realm {
		if let _ = NSClassFromString("XCTest") {
			return try! Realm(configuration: Realm.Configuration(fileURL: nil, inMemoryIdentifier: testSuite ?? "test", encryptionKey: nil, readOnly: false, schemaVersion: 0, migrationBlock: nil, objectTypes: nil))
		}

		return try! Realm();
	}
	
	func objects<T: Object>(_ type: T.Type, predicate: NSPredicate? = nil) -> Results<T>? {
		let realm = getRealm()
		realm.refresh()
		return predicate == nil ? realm.objects(type) : realm.objects(type).filter(predicate!)
	}
	
	func object<T: Object>(_ type: T.Type, key: Any) -> T? {
		
		let realm = getRealm()
		realm.refresh()
		
		return realm.object(ofType: type, forPrimaryKey: key)
	}
	
	func add<T: Object>(_ data: [T], update: Bool = true) {
		let realm = getRealm()
		realm.refresh()
		
		if realm.isInWriteTransaction {
			realm.add(data, update: .all)
		} else {
			try? realm.write {
				realm.add(data, update: .all)
			}
		}
	}
	
	func add<T: Object>(_ data: T, update: Bool = true) {
		add([data], update: update)
	}
	
	func runTransaction(action: () -> Void) {
		let realm = getRealm()
		realm.refresh()
		
		try? realm.write {
			action()
		}
	}
	
	func delete<T: Object>(_ data: [T]) {
		let realm = getRealm()
		realm.refresh()
		try? realm.write { realm.delete(data) }
	}
	
	func delete<T: Object>(_ data: T) {
		delete([data])
	}
}
