//
// Created by Sanfilippo, Calogero on 13/01/2020.
// Copyright (c) 2020 Accenture. All rights reserved.
//

import Combine
import Foundation

@available(iOS 13, *)
class CancellableWrapper: SmartCancellable {

	private let cancellable: Cancellable?

	init(_ cancellable: Cancellable?) {
		self.cancellable = cancellable
	}

	func cancel() {
		cancellable?.cancel()
	}
}
