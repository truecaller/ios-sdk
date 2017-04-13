//
//  TCProfileRequestButton.m
//  TrueSDK
//
//  Created by Guven Iscan on 23/12/2016.
//  Copyright © 2016 True Software Scandinavia AB. All rights reserved.
//

#import "TCProfileRequestButton.h"
#import "TCTrueSDK.h"
#import "TCUtils.h"

@implementation TCProfileRequestButton


- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        self.buttonStyle = TCButtonStyleBlue;
        self.buttonCornersStyle = TCButtonCornersStyleRounded;
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self != nil) {
        [self setup];
    }
    return self;
}

- (void)willMoveToWindow:(UIWindow *)newWindow
{
    [super willMoveToWindow:newWindow];
    if (self.buttonStyle == nil) {
        self.buttonStyle = TCButtonStyleBlue;
    }
    
    if (self.buttonCornersStyle == nil) {
        self.buttonCornersStyle = TCButtonCornersStyleRounded;
    }
}

- (void)setup
{
    //Set action
    [self addTarget:[TCTrueSDK sharedManager] action:@selector(requestTrueProfile) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setButtonStyle:(NSString *)buttonStyle
{
    //Convert any other value to the default custom value before assigning
    if ([TCProfileRequestButton isStyleCustom:buttonStyle]) {
        buttonStyle = TCButtonStyleCustom;
    }
    _buttonStyle = buttonStyle;
    [self setStyle:buttonStyle];
    
}

-(void)setButtonCornersStyle:(NSString *)buttonCornersStyle {
    _buttonCornersStyle = buttonCornersStyle;
    
    if ([_buttonCornersStyle isEqualToString:TCButtonCornersStyleRounded]) {
        self.layer.cornerRadius = 6.0;
    } else {
        self.layer.cornerRadius = 0.0;
    }
}

- (void)setStyle:(TCButtonStyle)buttonStyle
{
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    UIImage *image = [TCProfileRequestButton buttonIconImageForType:buttonStyle];
    if (image != nil) {
        [self setImage:image forState:UIControlStateNormal];
    }
    
    UIColor *backgroundColor = [TCProfileRequestButton backgroundColorForType:buttonStyle];
    if (backgroundColor != nil) {
        [self setBackgroundColor:backgroundColor];
    }
    
    [self setButtonTitleFor:buttonStyle];
    [self setButtonConstraintsFor:buttonStyle];
}

- (void)setButtonConstraintsFor:(TCButtonStyle)buttonStyle
{
    //Do not set anything for custom style
    if ([TCProfileRequestButton isStyleCustom:buttonStyle]) {
        return;
    }
    
    //Set UI
    CGFloat padding = 12.0;
    CGFloat imageSide = 32.0;
    
    //Set all insets to have left and right equal values so LTR and RTL language switch does not mess up the UI
    [self setContentEdgeInsets:UIEdgeInsetsMake(padding, padding / 2, padding, padding / 2)];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0.0, padding / 2, 0.0, padding / 2)];
    [self setImageEdgeInsets:UIEdgeInsetsMake(0.0, padding / 2, 0.0, padding / 2)];
    
    //Add constraints for title size and font, image size and button height
    NSLayoutConstraint *titlePositionYConstraint = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
    NSLayoutConstraint *imageHeightConstraint = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:imageSide];
    NSLayoutConstraint *imageWidthConstraint = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:imageSide];
    NSLayoutConstraint *imagePositionYConstraint = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:imageSide + 2 * padding];
    
    [self addConstraint:titlePositionYConstraint];
    [self.imageView addConstraint:imageHeightConstraint];
    [self.imageView addConstraint:imageWidthConstraint];
    [self addConstraint:imagePositionYConstraint];
    [self addConstraint:heightConstraint];
    
    //TODO: Issue with RTL and LTR languages at the moment is not solved (this is a temp workaround)
    if ([UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionLeftToRight) {
        NSLayoutConstraint *titleTrailingConstraint = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-padding];
        [self addConstraint:titleTrailingConstraint];
    } else {
        NSLayoutConstraint *titleTrailingConstraint = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:padding];
        [self addConstraint:titleTrailingConstraint];
    }
}

- (void)setButtonTitleFor:(TCButtonStyle)buttonStyle
{
    //Do not set anything for custom style
    if ([TCProfileRequestButton isStyleCustom:buttonStyle]) {
        return;
    }
    //Do not override user values for title
    if (self.currentTitle != nil ||
        self.currentAttributedTitle != nil) {
        return;
    }

    //Prepare the title text
    NSString *message = NSLocalizedStringFromTableInBundle(@"truebutton.title",
                                                          @"Localizable",
                                                          [TCUtils resourcesBundle],
                                                          @"TrueSDK button title");
    
    UIColor *textColorNormal = [TCProfileRequestButton textColorForType:buttonStyle];
    if (textColorNormal != nil) {
        UIColor *textColorHighlighted = [UIColor lightGrayColor];
        //Normal state
        [self setTitleColor:textColorNormal forState:UIControlStateNormal];
        //Highlighted state
        [self setTitleColor:textColorHighlighted forState:UIControlStateHighlighted];
    }

    //Set the title text and alignment
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self setTitle:message forState:UIControlStateNormal];
}

+ (BOOL)isStyleCustom:(TCButtonStyle)buttonStyle
{
    TCButtonStyle buttonStyleLowercase = buttonStyle.lowercaseString;
    if ([buttonStyleLowercase isEqualToString:TCButtonStyleBlue]) {
        return NO;
    } else if ([buttonStyleLowercase isEqualToString:TCButtonStyleWhite]) {
        return NO;
    }
    return YES;
}

+ (UIColor *)trueBlueColor
{
    return [UIColor colorWithRed:0.07 green:0.50 blue:1.00 alpha:1.0];
}

+ (UIImage *)buttonIconImageForType:(TCButtonStyle)buttonStyle
{
    NSString *imageName = nil;
    UIImage *image = nil;
    
    TCButtonStyle buttonStyleLowercase = buttonStyle.lowercaseString;
    if ([buttonStyleLowercase isEqualToString:TCButtonStyleBlue] || [buttonStyleLowercase isEqualToString:TCButtonStyleWhite]) {
        imageName = @"tc_logo";
    }
    
    if (imageName != nil) {
        NSBundle *frameworkBundle = [NSBundle bundleForClass:[self class]];
        image = [UIImage imageNamed:imageName inBundle:frameworkBundle compatibleWithTraitCollection:nil];
    }
    
    return image;
}

+ (UIColor *)backgroundColorForType:(TCButtonStyle)buttonStyle
{
    UIColor *backgroundColor = nil;
    
    TCButtonStyle buttonStyleLowercase = buttonStyle.lowercaseString;
    if ([buttonStyleLowercase isEqualToString:TCButtonStyleBlue]) {
        backgroundColor = [TCProfileRequestButton trueBlueColor];
    } else if ([buttonStyleLowercase isEqualToString:TCButtonStyleWhite]) {
        backgroundColor = [UIColor whiteColor];
    }
    
    return backgroundColor;
}

+ (UIColor *)textColorForType:(TCButtonStyle)buttonStyle
{
    UIColor *textColor = nil;
    
    TCButtonStyle buttonStyleLowercase = buttonStyle.lowercaseString;
    if ([buttonStyleLowercase isEqualToString:TCButtonStyleBlue]) {
        textColor = [UIColor whiteColor];
    } else if ([buttonStyleLowercase isEqualToString:TCButtonStyleWhite]) {
        textColor = [TCProfileRequestButton trueBlueColor];
    }
    
    return textColor;
}

@end
