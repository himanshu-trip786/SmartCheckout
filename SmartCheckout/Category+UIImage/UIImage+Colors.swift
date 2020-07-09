//
// Created by Calogero Sanfilippo on 2019-05-05.
// Copyright (c) 2019 Accenture. All rights reserved.
//

import UIKit

extension UIImage {

	static func imageFromColor(_ color: UIColor) -> UIImage? {

		let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)

		UIGraphicsBeginImageContext(rect.size)

		defer {
			UIGraphicsEndImageContext()
		}

		let context = UIGraphicsGetCurrentContext()
		context?.setFillColor(color.cgColor)
		context?.fill(rect)

		let image = UIGraphicsGetImageFromCurrentImageContext()

		return image
	}
}
