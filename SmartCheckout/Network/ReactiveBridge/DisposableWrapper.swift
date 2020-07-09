//
// Created by Sanfilippo, Calogero on 2019-08-06.
// Copyright (c) 2019 Accenture. All rights reserved.
//

import Foundation
import ReactiveSwift

final class DisposableWrapper: NSObject {

	private let disposable: Disposable?

	@objc var isDisposed: Bool {
		disposable?.isDisposed ?? false
	}

	init(disposable: Disposable?) {
		self.disposable = disposable
	}

	@objc func dispose() {
		self.disposable?.dispose()
	}
}

extension DisposableWrapper: SmartCancellable {
	func cancel() {
		self.dispose()
	}
}
