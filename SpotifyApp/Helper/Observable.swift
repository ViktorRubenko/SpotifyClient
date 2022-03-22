//
//  Observable.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 10.03.2022.
//

import Foundation

final class Observable<T> {
    
    typealias Listener = (T) -> Void
    
    private var listeners: [UUID: Listener] = [:]
    var value: T {
        didSet {
            listeners.values.forEach {
                $0(value)
            }
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    @discardableResult
    func bind(_ listener: @escaping Listener) -> UUID {
        let uuid = UUID()
        listeners[uuid] = listener
        return uuid
    }
    
    func removeBind(uuid: UUID) {
        listeners[uuid] = nil
    }
}
