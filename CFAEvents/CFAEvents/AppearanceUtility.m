//
//  AppearanceUtility.m
//  CFAEvents
//
//  Created by Robyn Van Deventer on 24/02/2016.
//  Copyright © 2016 Robyn Van Deventer. All rights reserved.
//

#import "AppearanceUtility.h"

@implementation AppearanceUtility

@end

@implementation UIColor (AppearanceUtility)

+ (UIColor *)colorFromHexString:(NSString *)hexString
{
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

//Application Background Color
+ (UIColor *)backgroundColor    {   return [UIColor colorFromHexString:@"#F2F2F2"];    }

//Incident Status Colors
+ (UIColor *)goingColor         {   return [UIColor colorFromHexString:@"#FF4444"];    }
+ (UIColor *)controlledColor    {   return [UIColor colorFromHexString:@"#33B5E5"];    }
+ (UIColor *)containedColor     {   return [UIColor colorFromHexString:@"#AA66CC"];    }
+ (UIColor *)safeColor          {   return [UIColor colorFromHexString:@"#99CC00"];    }

//Detail View Controller Colors
+ (UIColor *)textLabelColor     {   return [UIColor grayColor];                        }

@end

@implementation UIFont (AppearanceUtility)

//Detail View Controller Fonts
+ (UIFont *)titleFont           {   return [UIFont systemFontOfSize:24];               }
+ (UIFont *)titleLabelFont      {   return [UIFont boldSystemFontOfSize:16];           }
+ (UIFont *)textLabelFont       {   return [UIFont systemFontOfSize:16];               }

//Table View Fonts
+ (UIFont *)cellFont            {   return [UIFont boldSystemFontOfSize:15];           }

@end
