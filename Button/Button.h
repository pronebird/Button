//
//  Button.h
//  Button
//
//  Created by pronebird on 11/19/15.
//  Copyright © 2015 pronebird. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface Button : UIControl

@property (nonatomic, readonly) UILabel *titleLabel;
@property (nonatomic, readonly) UIImageView *imageView;

@property (nonatomic) IBInspectable NSString *title;
@property (nonatomic) IBInspectable UIColor *titleColor;
@property (nonatomic) IBInspectable UIColor *titleHighlightedColor;
@property (nonatomic) IBInspectable UIColor *titleDisabledColor;
@property (nonatomic) IBInspectable UIImage *image;
@property (nonatomic) IBInspectable UIFont *font;

@property(nonatomic,getter=isEnabled) IBInspectable BOOL enabled;

- (void)setTitle:(NSString *)title forState:(UIControlState)state;
- (NSString *)titleForState:(UIControlState)state;

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state;
- (UIColor *)titleColorForState:(UIControlState)state;

- (void)setImage:(UIImage *)image forState:(UIControlState)state;
- (UIImage *)imageForState:(UIControlState)state;

@end