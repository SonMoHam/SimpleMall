//
//  RealmManager.swift
//  SimpleMall
//
//  Created by 손대홍 on 2022/11/28.
//

import Foundation
import RealmSwift

enum RealmError: Error {
    case objectReadFailed
}

final class RealmManager<T: RealmConvertible>
where
    T == T.RealmEntity.DomainEntity,
    T.RealmEntity: Object
{
    // ???: try catch 여부
    private var realm: Realm {
        return try! Realm()
    }
    
    func fetchAll() -> Result<[T], Error> {
        let objects = realm.objects(T.RealmEntity.self)
            .sorted(byKeyPath: "date", ascending: true)
            .map { $0.toDomain() }
        return .success(Array(objects))
    }
    
    func save(entity: T) -> Result<Void, Error> {
        do {
            try realm.write{
                realm.add(entity.toRealm())
            }
            return .success
        } catch {
            return .failure(error)
        }
    }
    
    func delete(entity: T) -> Result<Void, Error> {
        let targetID = entity.toRealm().uID()
        do {
            guard let object = realm.object(ofType: T.RealmEntity.self, forPrimaryKey: targetID)
            else {
                throw RealmError.objectReadFailed
            }
            try realm.write{
                realm.delete(object)
            }
            return .success
        } catch {
            return .failure(error)
        }
    }
}
