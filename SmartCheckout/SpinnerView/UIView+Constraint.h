//
//  UIView+Constraint.h
//  HMTargetApp
//
//  Created by Juyal, Rahul on 7/11/17.
//  Copyright © 2017 Accenture. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Constraint)

- (void) hm_addConstraintsForView:(UIView *) view toSuperView:(UIView *) superView;

@end

NS_ASSUME_NONNULL_END
