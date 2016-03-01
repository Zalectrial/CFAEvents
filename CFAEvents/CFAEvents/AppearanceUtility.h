//
//  AppearanceUtility.h
//  CFAEvents
//
//  Created by Robyn Van Deventer on 24/02/2016.
//  Copyright © 2016 Robyn Van Deventer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppearanceUtility : NSObject

/**
 *  Setup code for the navigation bars for the whole application
 */
+ (void)setupNavigationBar;

@end

@interface UIColor (AppearanceUtility)

/**
 *  Creates a rgb color from a hex code
 *
 *  @param hexString The hex code
 *
 *  @return The color
 */
+ (UIColor *)colorFromHexString:(NSString *)hexString;

//Application Background Color
+ (UIColor *)backgroundColor;

//Incident Status Colors
+ (UIColor *)goingColor;
+ (UIColor *)controlledColor;
+ (UIColor *)containedColor;
+ (UIColor *)safeColor;
+ (UIColor *)defaultColor;

//Detail View Controller Colors
+ (UIColor *)textLabelColor;

@end

@interface UIFont (AppearanceUtility)

//Detail View Controller Fonts
+ (UIFont *)titleFont;
+ (UIFont *)titleLabelFont;
+ (UIFont *)textLabelFont;

//Table View Controller Fonts
+ (UIFont *)cellFont;

@end

@interface UIImage (AppearanceUtility)

/**
 *  Colors an image with the specified color
 *
 *  @param color The color for the image
 *
 *  @return The colored image
 */
- (UIImage *)colorImage:(UIColor *)color;

@end
