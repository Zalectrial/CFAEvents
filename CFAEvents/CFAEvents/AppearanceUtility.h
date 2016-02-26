//
//  AppearanceUtility.h
//  CFAEvents
//
//  Created by Robyn Van Deventer on 24/02/2016.
//  Copyright © 2016 Robyn Van Deventer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppearanceUtility : NSObject

+ (void)setupNavigationBar;

@end

@interface UIColor (AppearanceUtility)

+ (UIColor *)colorFromHexString:(NSString *)hexString;

//Application Background Color
+ (UIColor *)backgroundColor;

//Incident Status Colors
+ (UIColor *)goingColor;
+ (UIColor *)controlledColor;
+ (UIColor *)containedColor;
+ (UIColor *)safeColor;

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

- (UIImage *)colorImage:(UIColor *)color;

@end
