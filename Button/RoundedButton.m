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

- (void)applyAttributesForState:(UIControlState)state {
    [super applyAttributesForState:state];
    
    UIColor *textColor = [self preferredAttributeForState:state key:ButtonTitleColorAttributeKey];
    CGFloat borderWidth = [[self preferredAttributeForState:state key:RoundedButtonBorderWidthAttributeKey] doubleValue];
    CGFloat borderRadius = [[self preferredAttributeForState:state key:RoundedButtonBorderRadiusAttributeKey] doubleValue];
    
    self.layer.borderColor = textColor.CGColor;
    self.layer.borderWidth = borderWidth;
    self.layer.cornerRadius = borderRadius;
}

@end
