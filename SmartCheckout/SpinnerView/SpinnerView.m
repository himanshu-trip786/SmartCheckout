//
//  SpinnerView.m
//  HMTargetApp
//
//  Created by Denys.Meloshyn on 4/15/14.
//  Copyright (c) 2014 accenture. All rights reserved.
//

#import "SpinnerView.h"

#import "UIView+Constraint.h"

@implementation SpinnerView

+ (instancetype)shared
{
    static dispatch_once_t onceToken = 0;
    static SpinnerView *shareInstance = nil;
    
    // Init singleton
    dispatch_once(&onceToken, ^{
        shareInstance = [[SpinnerView alloc] init];
    });
    
    return shareInstance;
}

#pragma mark - Private methods

- (void)startSpinner
{
    // Remove spinner animation
    [self stopSpinner];
    
    // Add rotation animation
    CABasicAnimation *fullRotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    fullRotation.fromValue = @0.0;
    fullRotation.toValue = @( (360 * M_PI) / 180 );
    fullRotation.duration = 1;
    fullRotation.repeatCount = INFINITY;
    fullRotation.removedOnCompletion = NO;
    
    [self.spinnerImageView.layer addAnimation:fullRotation forKey:@"360"];
}

- (void)stopSpinner
{
    // Remove spinner animation
    [self.spinnerImageView.layer removeAllAnimations];
}

- (BOOL)isSpinnerAddedToTheView:(UIView *)rootView
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass: %@", [self class]];
    NSArray *filtereItems = [rootView.subviews filteredArrayUsingPredicate:predicate];
    
    if ([filtereItems count] > 0) {
        return YES;
    }
    
    return NO;
}

#pragma mark - Public methods

- (void)removeSpinnerFromView:(UIView *)rootView
{
    [self removeSpinnerFromView:rootView withAnimation:NO];
}

- (void)removeSpinnerFromView:(UIView *)rootView withAnimation:(BOOL)animation
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass: %@", [self class]];
    NSArray *filtereItems = [rootView.subviews filteredArrayUsingPredicate:predicate];
    
    if ([filtereItems count] > 0) {
        SpinnerView *spinnerView  = [filtereItems firstObject];
        [spinnerView stopSpinner];
        
        if (animation) {
            [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                [spinnerView setAlpha:0.0];
            } completion:^(BOOL finished) {
                [spinnerView removeFromSuperview];
            }];
        } else {
            [spinnerView removeFromSuperview];
        }
        
    }
}

- (void)showInView:(UIView *)rootView
{
    // Add spinner only when we couldn't find it in the view
    if( ![self isSpinnerAddedToTheView:rootView] ) {
        // Get Xib file
        NSArray *nibItems = [[NSBundle mainBundle] loadNibNamed:@"SpinnerView" owner:nil options:nil];
        SpinnerView *spinnerView = [nibItems firstObject];
        spinnerView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [rootView addSubview:spinnerView];
	
		[self hm_addConstraintsForView:spinnerView toSuperView:rootView];
        [spinnerView performSelector:@selector(startSpinner) withObject:nil afterDelay:0.0];
    }
}

@end
