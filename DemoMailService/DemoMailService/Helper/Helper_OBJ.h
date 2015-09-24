
//
//  Created by Solution Analysts Pvt. Ltd. on 29/05/15.
//  Copyright (c) 2015 Solution Analysts Pvt. Ltd.. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface Helper_OBJ : NSObject

+ (NSPredicate*)getPredicateWithFormat:(NSString*)str;

+ (NSInteger)getWeekDayFromDate:(NSDate*)date;

+ (NSDate*)getDateWithSystemTimeZone:(NSDate*)date;

+ (void)printDate:(NSDate*)date;

+ (NSDate*)getDateFromString:(NSString*)str;

+ (NSString*)getStringFromData:(NSData*)data;

+ (void)getDirectionFor:(double)lat1 long1:(double)long1 lat2:(double)lat2 long2:(double)long2;

+ (NSString*)getStringForDirection:(double)lat1 long1:(double)long1 lat2:(double)lat2 long2:(double)long2;

+ (NSString*)getStringWithTwoFraction:(double)value;


+ (BOOL)isTodayDate:(NSDate*)date;

+ (NSDate*)getDateByRemovingSecond:(NSDate*)date;

+ (NSString*)getDiffrenceBetweenDates:(NSDate*)date1 date2:(NSDate*)date2;

+ (NSString*)getStringFromDateWithMonth:(NSDate*)date;

+ (NSString*)getTimeFromDate:(NSDate*)date;

+ (NSString*)getDateStringWithDay:(NSDate*)date;

+ (BOOL)validateEmail:(NSString *)inputText;

+ (UIImage*)resizeImage:(UIImage*)image withWidth:(CGFloat)width withHeight:(CGFloat)height;

+ (NSString*)getMobileNumberInUSFormat:(NSString*)strNumber;

+ (CGSize)findHeightForText:(NSString *)text havingWidth:(CGFloat)widthValue andFont:(UIFont *)font;

@end
