//
//  Button+Subclassing.h
//  Button
//
//  Created by pronebird on 11/19/15.
//  Copyright © 2015 pronebird. All rights reserved.
//

#import "Button.h"

FOUNDATION_EXPORT NSString * ButtonTitleTextAttributeKey;
FOUNDATION_EXPORT NSString * ButtonTitleColorAttributeKey;
FOUNDATION_EXPORT NSString * ButtonImageAttributeKey;

@interface Button (Subclassing)

- (void)commonInit;

- (void)setAttributeForState:(UIControlState)state key:(NSString *)key value:(id)value;
- (id)attributeForState:(UIControlState)state key:(NSString *)key;
- (id)preferredAttributeForState:(UIControlState)state key:(NSString *)key;
- (void)applyAttributesForState:(UIControlState)state;

@end