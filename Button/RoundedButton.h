//
//  RoundedButton.h
//  Button
//
//  Created by pronebird on 11/19/15.
//  Copyright © 2015 pronebird. All rights reserved.
//

#import "Button.h"

IB_DESIGNABLE
@interface RoundedButton : Button

@property (nonatomic) IBInspectable CGFloat borderWidth;
@property (nonatomic) IBInspectable CGFloat borderRadius;

@end
