//
//  ThreadingFixes.swift
//  TapSwiftFixes
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class    Dispatch.DispatchQueue
import class    Foundation.NSThread.Thread
import func     ObjectiveC.objc_sync.objc_sync_enter
import func     ObjectiveC.objc_sync.objc_sync_exit

@discardableResult public func synchronized<T>(_ lock: Any, _ body: () throws -> T) rethrows -> T {

    objc_sync_enter(lock)

    defer {

        objc_sync_exit(lock)
    }

    return try body()
}

public func performOnMainThread(_ work: @escaping @convention(block) () -> Void) {

    if Thread.isMainThread {

        work()
        return
    }

    DispatchQueue.main.async(execute: work)
}

public func performOnBackgroundThread(_ work: @escaping @convention(block) () -> Void) {

    if !Thread.isMainThread {

        work()
        return
    }

	#if os(iOS)
	DispatchQueue.global(qos: .background).async(execute: work)
	#else
	DispatchQueue.global(priority: .background).async(execute: work)
	#endif
}
