//
//  TCProfileRequestButton.h
//  TrueSDK
//
//  Created by Guven Iscan on 23/12/2016.
//  Copyright © 2016 True Software Scandinavia AB. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 * @typedef TCButtonStyle
 * @brief A list of available button styles. Default is TCButtonStyleBlue.
 * @constant TCButtonStyleCustom Custom Style
 * @constant TCButtonStyleBlue The entire button is blue but the image and text are white
 * @constant TCButtonStyleWhite The entire button is white but the image and text are blue
 */
typedef NSString *TCButtonStyle NS_STRING_ENUM;

static TCButtonStyle const TCButtonStyleCustom = @"";
static TCButtonStyle const TCButtonStyleWhite = @"white";
static TCButtonStyle const TCButtonStyleBlue = @"blue";

/*!
 * @typedef TCButtonCornersStyle
 * @brief A list of available button corners styles. Default is TCButtonCornersStyleRounded.
 * @constant TCButtonCornersStyleRounded The corners of the button are rounded (radius = 6.0)
 * @constant TCButtonCornersStyleFlat The corners of the button are flat (radius = 0.0)
 */
typedef NSString *TCButtonCornersStyle NS_STRING_ENUM;

static TCButtonCornersStyle const TCButtonCornersStyleRounded = @"rounded";
static TCButtonCornersStyle const TCButtonCornersStyleFlat = @"flat";

/*!
 * @header TCProfileRequestButton.h
 * @brief Out-of-the box TrueSDK button which automatically sends True Profile Request when pressed by the user
 */

IB_DESIGNABLE
@interface TCProfileRequestButton : UIButton

/*!
 * @discussion Use TCButtonStyle enum values. Default value is TCButtonStyleCustom.
 * NSString is used instead of TCButtonStyle so it can be set from IB.
 * If a value is set out of the allowed range the default value is applied.
 */
@property(nonatomic) IBInspectable NSString *buttonStyle;

/*!
 * @discussion Use TCButtonCornersStyle enum values. Default value is TCButtonCornersStyleRounded.
 * NSString is used instead of TCButtonCornersStyle so it can be set from IB.
 * If a value is set out of the allowed range the default value is applied.
 */
@property(nonatomic) IBInspectable NSString *buttonCornersStyle;

/*!
 * @brief Returns an icon image with Truecaller logo
 * @param buttonStyle A string enum with predefined button styles
 * @return Image specified by button style (or nil for custom style)
 */
+ (UIImage *)buttonIconImageForType:(TCButtonStyle)buttonStyle;


/*!
 * @brief Returns the color for the given style
 * @param buttonStyle A string enum with predefined button styles
 * @return Background Color specified by button style (or nil for custom style)
 */
+ (UIColor *)backgroundColorForType:(TCButtonStyle)buttonStyle;


/*!
 * @brief Returns the text color for the given style
 * @param buttonStyle A string enum with predefined button styles
 * @return Text Color specified by button style (or nil for custom style)
 */
+ (UIColor *)textColorForType:(TCButtonStyle)buttonStyle;

@end
