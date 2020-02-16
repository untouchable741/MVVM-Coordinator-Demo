//
//  RxViewModel.swift
//  GitHubUsersDemo
//
//  Created by TAI VUONG on 2/16/20.
//  Copyright © 2020 TAI VUONG. All rights reserved.
//

import Foundation

import RxRelay
import RxCocoa
import RxSwift

enum ViewModelState<T>: Equatable {
    case idle
    case loading(String?)
    case completed(T)
    case error(Error)
}

func ==<T>(lhs: ViewModelState<T>, rhs: ViewModelState<T>) -> Bool {
    switch (lhs, rhs) {
    case (.idle, .idle): return true
    case (.loading, .loading): return true
    case (.completed, .completed): return true
    case (.error, .error): return true
    default: return false
    }
}

protocol RxViewModel {
    associatedtype DataType
    var stateObservable: BehaviorRelay<ViewModelState<DataType>> { get set }
    func setState(_ newState: ViewModelState<DataType>)
    func handleError<E>(_ error: Error) -> PrimitiveSequence<MaybeTrait, E>
}

extension RxViewModel {
    
    func handleError<E>(_ error: Error) -> PrimitiveSequence<MaybeTrait, E> {
        setState(.error(error))
        return Maybe.empty()
    }
    
    func setState(_ newState: ViewModelState<DataType>) {
        stateObservable.accept(newState)
    }
}
