//
//  Task.swift
//  Deferred
//
//  Created by Zachary Waldowski on 9/16/18.
//  Copyright © 2018 Big Nerd Ranch. Licensed under MIT.
//

#if SWIFT_PACKAGE
import Deferred
#endif

/// An interface describing a thread-safe way for interacting with the result
/// of some work that may either succeed or fail at some point in the future.
///
/// A "task" is a superset of a future where the asynchronously-determined value
/// represents 1 or more exclusive states. These states can be abstracted over
/// by extensions on the task protocol. The future value is almost always the
/// `TaskResult` type, but many types conforming to `TaskProtocol` may exist.
///
/// - seealso: `FutureProtocol`
public protocol TaskProtocol: FutureProtocol where Value: Either, Value.Left == Error {
    /// A type that represents the success of some asynchronous work.
    associatedtype SuccessValue where SuccessValue == Value.Right

    /// Call some `body` closure if the task successfully completes.
    ///
    /// - parameter executor: A context for handling the `body`.
    /// - parameter body: A closure to be invoked when the result is determined.
    ///  * parameter value: The determined success value.
    /// - seealso: `FutureProtocol.upon(_:execute:)`
    func uponSuccess(on executor: Executor, execute body: @escaping(_ value: SuccessValue) -> Void)

    /// A type that represents the failure of some asynchronous work.
    typealias FailureValue = Error

    /// Call some `body` closure if the task fails.
    ///
    /// - parameter executor: A context for handling the `body`.
    /// - parameter body: A closure to be invoked when the result is determined.
    ///  * parameter error: The determined failure value.
    /// - seealso: `FutureProtocol.upon(_:execute:)`
    func uponFailure(on executor: Executor, execute body: @escaping(_ error: FailureValue) -> Void)

    /// Tests whether the underlying work has been cancelled.
    ///
    /// An implementation should be a "best effort". By default, no cancellation
    /// is supported, and thus cannot become cancelled.
    ///
    /// Should an implementation choose to be cancellable, it should fully
    /// implement cancellability with `cancel`.
    var isCancelled: Bool { get }

    /// Attempt to cancel the underlying work.
    ///
    /// An implementation should be a "best effort". By default, no cancellation
    /// is supported, and this method does nothing.
    ///
    /// There are several situations in which a valid implementation may not
    /// actually cancel:
    /// * The work has already completed.
    /// * The work has entered an uncancelable state.
    /// * An underlying task is not cancellable.
    ///
    /// Should an implementation choose to be cancellable, it should fully
    /// implement cancellability with `isCancelled`.
    func cancel()
}

// MARK: - Default implementation

extension TaskProtocol {
    public var isCancelled: Bool {
        return false
    }

    public func cancel() {}
}

// MARK: - Conditional conformances

extension Future: TaskProtocol where Value: Either, Value.Left == Error {
    public typealias SuccessValue = Value.Right

    /// Create a future having the same underlying task as `other`.
    public init<OtherTask: TaskProtocol>(task other: OtherTask) where OtherTask.SuccessValue == SuccessValue, OtherTask.FailureValue == FailureValue {
        self = other as? Future<Value> ?? other.every {
            $0.withValues(ifLeft: Value.init(left:), ifRight: Value.init(right:))
        }
    }

    /// Create a future having the same underlying task as `other`.
    public init<OtherFuture: FutureProtocol>(success other: OtherFuture) where OtherFuture.Value == SuccessValue {
        self = other.every(per: Value.init(right:))
    }
}

extension Deferred: TaskProtocol where Value: Either, Value.Left == Error {
    public typealias SuccessValue = Value.Right
}