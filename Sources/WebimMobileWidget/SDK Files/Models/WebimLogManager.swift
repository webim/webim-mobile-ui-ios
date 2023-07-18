//
//  WebimLogManager.swift
//  WebimClientLibrary_Example
//
//  Created by Аслан Кутумбаев on 16.06.2022.
//  Copyright © 2022 Webim. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation
import WebimMobileSDK

public protocol WebimLogManagerObserver {
    func didGetNewLog(log: String)
}

public protocol WebimLogManagerSubject {
    func add(observer: WebimLogManagerObserver)
    func remove(observer: WebimLogManagerObserver)
    func notify(with log: String)
}

public class WebimLogManager: WebimLogManagerSubject {

    public static let shared = WebimLogManager()

    var observerCollection = NSMutableSet()

    private var logs: [String]
    private let safeQueue = DispatchQueue(label: "com.WebimLogger.arrayQueue", attributes: .concurrent)

    init() {
        logs = []
    }

    public func getLogs() -> [String] {
        return logs
    }

    public func add(observer: WebimLogManagerObserver) {
        observerCollection.add(observer)
    }

    public func remove(observer: WebimLogManagerObserver) {
        observerCollection.remove(observer)
    }

    public func notify(with log: String) {
        observerCollection.forEach { observer in
            guard let observer = observer as? WebimLogManagerObserver else { return }
            observer.didGetNewLog(log: log)
        }
    }
}

extension WebimLogManager: WebimLogger {
    public func log(entry: String) {
        print(entry)
        notify(with: entry)
        safeQueue.async(flags: .barrier) {
            self.logs.append(entry)
        }
    }
}
