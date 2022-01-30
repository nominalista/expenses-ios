//
//  Query+Combine.swift
//  Expenses
//
//  Created by Nominalista on 23/01/2022.
//

import Combine
import FirebaseFirestore

extension Query {
    
    struct Publisher: Combine.Publisher {
        
        typealias Output = QuerySnapshot
        typealias Failure = Error
        
        private let query: Query
        private let includeMetadataChanges: Bool
        
        init(_ query: Query, includeMetadataChanges: Bool) {
            self.query = query
            self.includeMetadataChanges = includeMetadataChanges
        }
        
        func receive<S>(
            subscriber: S
        ) where S : Subscriber, Failure == S.Failure, Output == S.Input {
            let subscription = QuerySnapshot.Subscription(
                subscriber: subscriber,
                query: query,
                includeMetadataChanges: includeMetadataChanges
            )
            subscriber.receive(subscription: subscription)
        }
    }
    
    func publisher(includeMetadataChanges: Bool = false) -> AnyPublisher<QuerySnapshot, Error> {
        Publisher(self, includeMetadataChanges: includeMetadataChanges).eraseToAnyPublisher()
    }
}

private extension QuerySnapshot {
    
    class Subscription<Subscriber: Combine.Subscriber>:
        Combine.Subscription where Subscriber.Input == QuerySnapshot, Subscriber.Failure == Error {
        
        private var listenerRegistration: ListenerRegistration?
        
        init(subscriber: Subscriber, query: Query, includeMetadataChanges: Bool) {
            listenerRegistration = query.addSnapshotListener(
                includeMetadataChanges: includeMetadataChanges
            ) { querySnapshot, error in
                if let error = error {
                    subscriber.receive(completion: .failure(error))
                } else if let querySnapshot = querySnapshot {
                    _ = subscriber.receive(querySnapshot)
                } else {
                    subscriber.receive(completion: .failure(FirebaseError.unknown))
                }
            }
        }
        
        func request(_ demand: Subscribers.Demand) {
            // Do nothing.
        }
        
        func cancel() {
            listenerRegistration?.remove()
            listenerRegistration = nil
        }
    }
}
