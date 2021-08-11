//
//  DisclaimerView.m
//  TrueSDK
//
//  Created by Ashutosh Roy on 10/08/21.
//  Copyright © 2021 True Software Scandinavia AB. All rights reserved.
//

#import "DisclaimerView.h"
#import "TCUtils.h"

NSString *const kTCTermsURL = @"https://developer.truecaller.com/phone-number-verification/privacy-notice";

@implementation DisclaimerView

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    [self addDisclaimerSubViews:self];
}


-(void)addDisclaimerSubViews:(UIView *)view {
    UILabel *label = [UILabel new];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [label setTextColor:UIColor.whiteColor];
    
    NSInteger labelPadding = 8;
    
    NSString *termsString = NSLocalizedStringFromTableInBundle(@"truecaller.tandc.text",
                                                               @"Localizable",
                                                               [TCUtils resourcesBundle],
                                                               @"TrueSDK T&C string");
    
    NSString *termsButtonString = NSLocalizedStringFromTableInBundle(@"truecaller.tandc.buttonText",
                                                                     @"Localizable",
                                                                     [TCUtils resourcesBundle],
                                                                     @"TrueSDK T&C button title");
    
    NSRange termsRange = [termsString rangeOfString:termsButtonString];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString: termsString attributes:nil];
    [attributedString addAttribute: NSLinkAttributeName value: kTCTermsURL range: termsRange];
    
    UITapGestureRecognizer *tap= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openTermsAndConditions:)];
    label.userInteractionEnabled= YES;
    [label addGestureRecognizer:tap];

    // Assign attributedText to UILabel
    label.attributedText = attributedString;
    label.font = [UIFont systemFontOfSize:12.0];
    label.numberOfLines = 3;
    label.userInteractionEnabled = YES;
    
    [view addSubview:label];
    [label.leftAnchor constraintEqualToAnchor:view.leftAnchor constant:labelPadding].active = YES;
    [label.topAnchor constraintEqualToAnchor:view.topAnchor constant:labelPadding].active = YES;
    [label.bottomAnchor constraintEqualToAnchor:view.bottomAnchor constant:-labelPadding].active = YES;
    
    UIButton *mButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [mButton setImage:[self closeImage] forState:UIControlStateNormal];
    mButton.translatesAutoresizingMaskIntoConstraints = NO;
    mButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [mButton addTarget:self action:@selector(removeDisclaimer) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:mButton];
    [mButton.rightAnchor constraintEqualToAnchor:view.rightAnchor].active = YES;
    [mButton.leftAnchor constraintEqualToAnchor:label.rightAnchor].active = YES;
    [mButton.centerYAnchor constraintEqualToAnchor:label.centerYAnchor].active = YES;
    [mButton.widthAnchor constraintEqualToConstant:50].active = YES;
}

- (void)removeDisclaimer {
    [self setHidden:YES];
}

- (UIImage *)closeImage {
    NSBundle *frameworkBundle = [NSBundle bundleForClass:[self class]];
    NSString *imageName = @"ic_close_disclaimer";
    UIImage *image = [UIImage imageNamed:imageName inBundle:frameworkBundle compatibleWithTraitCollection:nil];
    return image;
}

-(void)openTermsAndConditions:(id)sender{
    NSURL *termsUrl = [NSURL URLWithString:kTCTermsURL];
    [[UIApplication sharedApplication] openURL: termsUrl];
}
@end
