//
//  UIView+Constraint.m
//  HMTargetApp
//
//  Created by Juyal, Rahul on 7/11/17.
//  Copyright © 2017 Accenture. All rights reserved.
//

#import "UIView+Constraint.h"

@implementation UIView (Constraint)

- (void) hm_addConstraintsForView:(UIView *) view toSuperView:(UIView *) superView
{
    NSArray *constraints;
    NSDictionary *viewsDictionary;
    if (superView != nil) {
        viewsDictionary = @{ @"view" : view };
        
        constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|"
                                                              options:0
                                                              metrics:nil
                                                                views:viewsDictionary];
        [superView addConstraints:constraints];
        
        // Set left & right constraints to the super view
        constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|"
                                                              options:0
                                                              metrics:nil
                                                                views:viewsDictionary];
        [superView addConstraints:constraints];
    }
}

@end
