//
//  RoundedButton.m
//  Button
//
//  Created by pronebird on 11/19/15.
//  Copyright © 2015 pronebird. All rights reserved.
//

#import "RoundedButton.h"
#import "Button+Subclassing.h"

static NSString * RoundedButtonBorderRadiusAttributeKey = @"borderRadius";
static NSString * RoundedButtonBorderWidthAttributeKey = @"borderWidth";
static NSString * RoundedButtonBorderColorAttributeKey = @"borderColor";

@implementation RoundedButton

- (void)commonInit {
    [super commonInit];
    
    self.layer.masksToBounds = YES;
    
    self.borderRadius = 4.0;
    self.borderWidth = 1.0;
}

- (void)setBorderRadius:(CGFloat)borderRadius {
    [self setAttributeForState:UIControlStateNormal key:RoundedButtonBorderRadiusAttributeKey value:@(borderRadius)];
}

- (CGFloat)borderRadius {
    return [[self attributeForState:UIControlStateNormal key:RoundedButtonBorderRadiusAttributeKey] doubleValue];
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    [self setAttributeForState:UIControlStateNormal key:RoundedButtonBorderWidthAttributeKey value:@(borderWidth)];
}

- (CGFloat)borderWidth {
    return [[self attributeForState:UIControlStateNormal key:RoundedButtonBorderWidthAttributeKey] doubleValue];
}

- (void)setBorderColor:(UIColor *)borderColor {
    [self setAttributeForState:UIControlStateNormal key:RoundedButtonBorderColorAttributeKey value:borderColor];
}

- (UIColor *)borderColor {
    return [self attributeForState:UIControlStateNormal key:RoundedButtonBorderColorAttributeKey];
}

- (void)setBorderColor:(UIColor *)borderColor forState:(UIControlState)state {
    [self setAttributeForState:state key:RoundedButtonBorderColorAttributeKey value:borderColor];
}

- (UIColor *)borderColorForState:(UIControlState)state {
    return [self attributeForState:state key:RoundedButtonBorderColorAttributeKey];
}

- (void)applyAttributesForState:(UIControlState)state {
    [super applyAttributesForState:state];
    
    UIColor *borderColor = [self preferredAttributeForState:state key:RoundedButtonBorderColorAttributeKey];
    CGFloat borderWidth = [[self preferredAttributeForState:state key:RoundedButtonBorderWidthAttributeKey] doubleValue];
    CGFloat borderRadius = [[self preferredAttributeForState:state key:RoundedButtonBorderRadiusAttributeKey] doubleValue];
    
    /*
     Use tintColor if borderColor is not set.
     */
    if(!borderColor) {
        borderColor = self.tintColor;
        
        if(state & UIControlStateHighlighted) {
            borderColor = [borderColor colorWithAlphaComponent:0.5];
        }
    }
    
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = borderWidth;
    self.layer.cornerRadius = borderRadius;
}

- (void)tintColorDidChange {
    [super tintColorDidChange];
    
    [self applyAttributesForState:self.state];
}

@end
