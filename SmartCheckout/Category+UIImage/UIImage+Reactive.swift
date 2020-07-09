//
//  UIImage+Reactive.swift
//  HMTargetApp
//
//  Created by katherine.stefaniak on 2020-03-23.
//  Copyright © 2020 Accenture. All rights reserved.
//

import Foundation
import ReactiveSwift


extension Reactive where Base: UIImageView {
    var visible: BindingTarget<Bool> {
        return makeBindingTarget{ $0.isHidden = !$1 }
          
    }
    
    var alpha: BindingTarget<CGFloat> {
        return makeBindingTarget { $0.alpha = $1 }
    }
}
