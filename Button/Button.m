//
//  Button.m
//  Button
//
//  Created by pronebird on 11/19/15.
//  Copyright © 2015 pronebird. All rights reserved.
//

#import "Button.h"

NSString * ButtonTitleTextAttributeKey = @"titleText";
NSString * ButtonTitleColorAttributeKey = @"titleColor";
NSString * ButtonImageAttributeKey = @"image";

static void * ButtonImageViewObserverContext = &ButtonImageViewObserverContext;

@interface Button ()

@property (nonatomic, readwrite) UILabel *titleLabel;
@property (nonatomic, readwrite) UIImageView *imageView;

@property (nonatomic) UIStackView *stackView;
@property (nonatomic) NSMutableDictionary *attributes;

@property (nonatomic) BOOL isTouchDown;
@property (nonatomic) BOOL isTouchUp;

@end

@implementation Button

@dynamic enabled;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(!self) {
        return nil;
    }
    
    [self commonInit];
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(!self) {
        return nil;
    }
    
    [self commonInit];
    
    return self;
}

- (void)commonInit {
    self.opaque = NO;
    self.backgroundColor = [UIColor clearColor];
    
    self.layoutMargins = UIEdgeInsetsMake(4, 4, 4, 4);
    
    self.attributes = [[NSMutableDictionary alloc] init];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.font = [UIFont systemFontOfSize:[UIFont buttonFontSize]];
    
    self.imageView = [[UIImageView alloc] init];
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageView.contentMode = UIViewContentModeRedraw;
    
    self.stackView = [[UIStackView alloc] initWithArrangedSubviews:@[ self.imageView, self.titleLabel ]];
    self.stackView.translatesAutoresizingMaskIntoConstraints = NO;
    self.stackView.axis = UILayoutConstraintAxisHorizontal;
    self.stackView.alignment = UIStackViewAlignmentCenter;
    self.stackView.distribution = UIStackViewDistributionFill;
    self.stackView.spacing = 4;
    self.stackView.userInteractionEnabled = NO;
    
    [self addSubview:self.stackView];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=0)-[stack]-(>=0)-|" options:0 metrics:nil views:@{ @"stack": self.stackView }]];
    
    [self.stackView.topAnchor constraintEqualToAnchor:self.layoutMarginsGuide.topAnchor].active = YES;
    [self.stackView.bottomAnchor constraintEqualToAnchor:self.layoutMarginsGuide.bottomAnchor].active = YES;
    [self.stackView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
    
    [self.imageView addObserver:self forKeyPath:@"image" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial) context:ButtonImageViewObserverContext];
}

- (void)dealloc {
    @try {
        [self.imageView removeObserver:self forKeyPath:@"image" context:ButtonImageViewObserverContext];
    }
    @catch (NSException *exception) {
        
    }
}

- (UIView *)viewForFirstBaselineLayout {
    return self.titleLabel;
}

- (UIView *)viewForLastBaselineLayout {
    return self.titleLabel;
}

#pragma mark - Key Value Observer
#pragma mark -

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if(context == ButtonImageViewObserverContext) {
        id newImage = change[NSKeyValueChangeNewKey];
        
        if([[NSNull null] isEqual:newImage]) {
            self.imageView.hidden = YES;
        }
        else {
            self.imageView.hidden = NO;
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - Attribute manipulations
#pragma mark -

- (void)setAttributeForState:(UIControlState)state key:(NSString *)key value:(id)value {
    NSDictionary *stateAttributes = self.attributes[ @(state) ];
    NSMutableDictionary *mutableStateAttributes = [stateAttributes mutableCopy] ?: [[NSMutableDictionary alloc] init];
    
    mutableStateAttributes[key] = value;
    
    id oldValue = stateAttributes[ @(state) ][key];
    
    self.attributes[ @(state) ] = [NSDictionary dictionaryWithDictionary:mutableStateAttributes];
    
    [self didChangeAttributeForKey:key oldValue:oldValue newValue:value state:state];
}

- (id)attributeForState:(UIControlState)state key:(NSString *)key {
    NSDictionary *stateAttributes = self.attributes[ @(state) ];
    
    return stateAttributes[key];
}

- (id)preferredAttributeForState:(UIControlState)state key:(NSString *)key {
    static NSDictionary *attributeTable;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        attributeTable = @{
                           @(UIControlStateNormal): @[ @(UIControlStateNormal) ],
                           @(UIControlStateHighlighted): @[ @(UIControlStateHighlighted), @(UIControlStateNormal) ],
                           @(UIControlStateSelected): @[ @(UIControlStateSelected), @(UIControlStateHighlighted), @(UIControlStateNormal) ],
                           @(UIControlStateDisabled): @[ @(UIControlStateDisabled), @(UIControlStateNormal) ]
                           };
    });
    
    NSArray *stateOrder = attributeTable[@(state)];
    
    for(NSNumber *stateNumber in stateOrder) {
        id value = [self attributeForState:[stateNumber unsignedIntegerValue] key:key];
        if(value) {
            return value;
        }
    }
    
    return nil;
}

#pragma mark - Attribute updates
#pragma mark -

- (void)didChangeAttributeForKey:(NSString *)key oldValue:(id)oldValue newValue:(id)newValue state:(UIControlState)state {
    if(state != self.state) {
        return;
    }
    
    [self applyAttributesForState:state];
}

- (void)applyAttributesForState:(UIControlState)state {
    NSString *titleText = [self preferredAttributeForState:state key:ButtonTitleTextAttributeKey];
    UIColor *titleColor = [self preferredAttributeForState:state key:ButtonTitleColorAttributeKey];
    UIImage *image = [self preferredAttributeForState:state key:ButtonImageAttributeKey];
    
    self.titleLabel.text = titleText;
    self.titleLabel.textColor = titleColor;
    
    if(![self.imageView.image isEqual:image]) {
        self.imageView.image = image;
    }
    
    self.imageView.tintColor = titleColor;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)applyAttributesForState:(UIControlState)state animated:(BOOL)animated {
    UIViewAnimationOptions options = (
                                      UIViewAnimationOptionCurveEaseInOut |
                                      UIViewAnimationOptionTransitionCrossDissolve |
                                      UIViewAnimationOptionBeginFromCurrentState |
                                      UIViewAnimationOptionAllowUserInteraction);
    
    void(^animations)() = ^{
        [self applyAttributesForState:self.state];
    };
    
    if(animated) {
        [UIView transitionWithView:self
                          duration:0.25
                           options:options
                        animations:animations completion:nil];
    }
    else {
        animations();
    }
}

#pragma mark - Common attributes
#pragma mark -

- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    [self setAttributeForState:state key:ButtonTitleTextAttributeKey value:title];
}

- (NSString *)titleForState:(UIControlState)state {
    return [self attributeForState:state key:ButtonTitleTextAttributeKey];
}

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state {
    [self setAttributeForState:state key:ButtonTitleColorAttributeKey value:color];
}

- (UIColor *)titleColorForState:(UIControlState)state {
    return [self attributeForState:state key:ButtonTitleColorAttributeKey];
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state {
    [self setAttributeForState:state key:ButtonImageAttributeKey value:image];
}

- (UIImage *)imageForState:(UIControlState)state {
    return [self attributeForState:state key:ButtonImageAttributeKey];
}

#pragma mark - Interface Builder
#pragma mark -

- (void)setTitle:(NSString *)title {
    [self setTitle:title forState:UIControlStateNormal];
}

- (NSString *)title {
    return [self titleForState:UIControlStateNormal];
}

- (void)setTitleColor:(UIColor *)titleColor {
    [self setTitleColor:titleColor forState:UIControlStateNormal];
}

- (UIColor *)titleColor {
    return [self titleColorForState:UIControlStateNormal];
}

- (void)setTitleHighlightedColor:(UIColor *)titleHighlightColor {
    [self setTitleColor:titleHighlightColor forState:UIControlStateHighlighted];
}

- (UIColor *)titleHighlightedColor {
    return [self titleColorForState:UIControlStateHighlighted];
}

- (void)setTitleDisabledColor:(UIColor *)titleDisabledColor {
    [self setTitleColor:titleDisabledColor forState:UIControlStateDisabled];
}

- (UIColor *)titleDisabledColor {
    return [self titleColorForState:UIControlStateDisabled];
}

- (void)setImage:(UIImage *)image {
    [self setImage:image forState:UIControlStateNormal];
}

- (UIImage *)image {
    return [self imageForState:UIControlStateNormal];
}

- (void)setFont:(UIFont *)font {
    self.titleLabel.font = font;
}

- (UIFont *)font {
    return self.titleLabel.font;
}

#pragma mark - Accessors
#pragma mark -

- (void)setHighlighted:(BOOL)highlighted {
    if(self.highlighted == highlighted) {
        return;
    }
    
    [super setHighlighted:highlighted];
    
    self.imageView.highlighted = highlighted;
    
    /*
     Animations logic
     */
    BOOL animated = ((self.isTracking || self.isTouchUp) && !self.isTouchDown);
    
    /*
     Apply attributes to button
     */
    [self applyAttributesForState:self.state animated:animated];
    
    /*
     Reset isTouchDown.
     This flag indicates the first touch. No animation should
     run on first touch.
     */
    if(self.isTouchDown) {
        self.isTouchDown = NO;
    }
    
    /*
     Reset isTouchUp.
     This flag indicates when touch released. Used to run the final animation after
     -endTrackingWithTouch:withEvent:
     */
    if(self.isTouchUp) {
        self.isTouchUp = NO;
    }
}

- (void)setSelected:(BOOL)selected {
    if(self.isSelected == selected) {
        return;
    }
    
    [super setSelected:selected];
    
    [self applyAttributesForState:self.state];
}

- (void)setEnabled:(BOOL)enabled {
    if(self.isEnabled == enabled) {
        return;
    }
    
    [super setEnabled:enabled];
    
    [self applyAttributesForState:self.state];
}

#pragma mark - UIControl subclassing
#pragma mark -

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    /*
     Set up isTouchDown to avoid running animation on touch
     */
    self.isTouchDown = YES;
    
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    /*
     Set up isTouchUp to run the final animation in -setHighlighted:
     */
    self.isTouchUp = YES;
}

@end
