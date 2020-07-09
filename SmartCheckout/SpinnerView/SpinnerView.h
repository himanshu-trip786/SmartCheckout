//
//  SpinnerView.h
//  HMTargetApp
//
//  Created by Denys.Meloshyn on 4/15/14.
//  Copyright (c) 2014 accenture. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SpinnerView : UIView

+ (instancetype)shared;

- (void)startSpinner;

- (void) showInView:(UIView *_Nullable) rootView;

- (void) removeSpinnerFromView:(UIView *_Nullable) rootView;

- (BOOL) isSpinnerAddedToTheView:(UIView *_Nullable) rootView;

- (void) removeSpinnerFromView:(UIView *_Nullable) rootView withAnimation:(BOOL) animation;

@property (strong, nonatomic) IBOutlet UIImageView *spinnerImageView;

@end

NS_ASSUME_NONNULL_END
