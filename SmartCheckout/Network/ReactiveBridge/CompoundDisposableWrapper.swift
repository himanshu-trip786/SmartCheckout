//
// Created by Sanfilippo, Calogero on 29/10/2019.
// Copyright (c) 2019 Accenture. All rights reserved.
//

import Foundation
import ReactiveSwift

final class CompoundDisposableWrapper: NSObject {

	private let compound = CompositeDisposable()

	@objc func addDisposable(_ disposable: DisposableWrapper?) {
		guard let concreteDisposable = disposable else {
			return
		}

		compound.add(AnyDisposable {
			concreteDisposable.dispose()
		})
	}

	@objc func dispose() {
		compound.dispose()
	}
}

extension CompoundDisposableWrapper: SmartCancellable {
	func cancel() {
		dispose()
	}
}
