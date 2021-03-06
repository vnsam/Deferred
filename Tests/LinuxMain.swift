//
//  LinuxMain.swift
//  DeferredTests
//
//  Created by Zachary Waldowski on 9/21/16.
//  Copyright © 2016 Big Nerd Ranch. Licensed under MIT.
//

import XCTest
@testable import DeferredTests
@testable import TaskTests

XCTMain([
    testCase(DeferredTests.allTests),
    testCase(DispatchSemaphoreLockingTests.allTests),
    testCase(ExistentialFutureTests.allTests),
    testCase(FilledDeferredTests.allTests),
    testCase(FutureCustomExecutorTests.allTests),
    testCase(FutureIgnoreTests.allTests),
    testCase(FutureTests.allTests),
    testCase(LockingTests.allTests),
    testCase(NSLockingTests.allTests),
    testCase(ObjectDeferredTests.allTests),
    testCase(POSIXReadWriteLockingTests.allTests),
    testCase(ProtectedTests.allTests),
    testCase(SwiftBugTests.allTests),

    testCase(TaskComprehensiveTests.allTests),
    testCase(TaskResultTests.allTests),
    testCase(TaskTests.allTests),
    testCase(TaskAsyncTests.allTests)
])
