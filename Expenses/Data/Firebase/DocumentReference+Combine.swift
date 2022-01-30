//
//  DocumentReference+Combine.swift
//  Expenses
//
//  Created by Nominalista on 23/01/2022.
//

import Combine
import FirebaseFirestore

extension DocumentReference {
    
    struct Publisher: Combine.Publisher {
        
        typealias Output = DocumentSnapshot
        typealias Failure = Error
        
        private let documentReference: DocumentReference
        private let includeMetadataChanges: Bool
        
        init(_ documentReference: DocumentReference, includeMetadataChanges: Bool) {
            self.documentReference = documentReference
            self.includeMetadataChanges = includeMetadataChanges
        }
        
        func receive<S>(
            subscriber: S
        ) where S : Subscriber, Failure == S.Failure, Output == S.Input {
            let subscription = DocumentSnapshot.Subscription(
                subscriber: subscriber,
                documentReference: documentReference,
                includeMetadataChanges: includeMetadataChanges
            )
            subscriber.receive(subscription: subscription)
        }
    }
    
    func publisher(includeMetadataChanges: Bool = false) -> AnyPublisher<DocumentSnapshot, Error> {
        Publisher(self, includeMetadataChanges: includeMetadataChanges).eraseToAnyPublisher()
    }
}

private extension DocumentSnapshot {
    
    class Subscription<Subscriber: Combine.Subscriber>:
        Combine.Subscription where Subscriber.Input == DocumentSnapshot, Subscriber.Failure == Error {
        
        private var listenerRegistration: ListenerRegistration?
        
        init(
            subscriber: Subscriber,
            documentReference: DocumentReference,
            includeMetadataChanges: Bool
        ) {
            listenerRegistration = documentReference.addSnapshotListener(
                includeMetadataChanges: includeMetadataChanges
            ) { documentSnapshot, error in
                if let error = error {
                    subscriber.receive(completion: .failure(error))
                } else if let documentSnapshot = documentSnapshot {
                    _ = subscriber.receive(documentSnapshot)
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
