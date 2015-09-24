
//
//  Created by Solution Analysts Pvt. Ltd. on 29/05/15.
//  Copyright (c) 2015 Solution Analysts Pvt. Ltd.. All rights reserved.
//

#import "Helper_OBJ.h"



@implementation Helper_OBJ

+ (NSPredicate*)getPredicateWithFormat:(NSString*)str{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:str];
    
    return predicate;
}

+ (NSInteger)getWeekDayFromDate:(NSDate*)date{
    
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    
    // Get the components for this date
    NSDateComponents *components = [gregorian components:  (NSCalendarUnitWeekday) fromDate: date];
    
    return components.weekday;
}

//+ (void)printDate:(NSDate*)date {
//    
//    NSString *dateString = [NSDateFormatter localizedStringFromDate:date
//                                                          dateStyle:NSDateFormatterShortStyle
//                                                          timeStyle:NSDateFormatterFullStyle];
//    NSLog(@"%@",dateString);
//}

+ (NSDate*)getDateWithSystemTimeZone:(NSDate*)date{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    
    [formatter setTimeZone:destinationTimeZone];
    
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm"];
    
    NSString *str = [formatter stringFromDate:date];
    
    NSDate *dateFinal = [formatter dateFromString:str];
    
    return dateFinal;
}

+ (NSDate*)getDateWithOnlyTime:(NSDate*)date{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    //[formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];

    [formatter setDateFormat:@"hh:mm"];
    
    NSString *str = [formatter stringFromDate:date];
    
    NSDate *dateFinal = [formatter dateFromString:str];
    
    return dateFinal;
}

+ (NSDate*)getDateFromString:(NSString*)str {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"MM/yyyy"];
    
    NSDate *date = [formatter dateFromString:str];
    
    return date;
}



+ (void)getDirectionFor:(double)lat1 long1:(double)long1 lat2:(double)lat2 long2:(double)long2
{
    NSString *googleMapUrlString = [NSString stringWithFormat:@"http://maps.google.com/?saddr=%f,%f&daddr=%f,%f", lat1, long1, lat2, long2];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:googleMapUrlString]];
}

+ (NSString*)getStringForDirection:(double)lat1 long1:(double)long1 lat2:(double)lat2 long2:(double)long2
{
    NSString *googleMapUrlString = [NSString stringWithFormat:@"http://maps.google.com/?saddr=%f,%f&daddr=%f,%f", lat1, long1, lat2, long2];
    
    return googleMapUrlString;
}

+ (NSString*)getStringWithTwoFraction:(double)value{
    
    NSString *str = [NSString stringWithFormat:@"%.02f",value];
    
    return str;
}



+ (NSString*)getStringFromWeekDay:(NSInteger)day {
    
    NSString *strDay = @"";
    
    if(day==1){
        
        strDay = @"SUN";
    }
    else if (day == 2){
        
        strDay = @"MON";
    }
    else if(day == 3)
    {
        strDay = @"TUE";
    }
    else if (day == 4){
        
        strDay = @"WED";
    }
    else if (day == 5){
        
        strDay = @"THU";
    }
    else if(day == 6)
    {
        strDay = @"FRI";
    }
    else {
        
        strDay = @"SAT";
    }
    
    return strDay;
}

+ (NSString*)getDateStringWithDay:(NSDate*)date {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitWeekday) fromDate:date];
    NSInteger weekDay = [components weekday];
    
    NSString *strDay = [Helper_OBJ getStringFromWeekDay:weekDay];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    
    NSString *strFinal = [NSString stringWithFormat:@"%@, %@",strDay,strDate];
    
    return strFinal;
}

+ (NSString*)getTimeFromDate:(NSDate*)date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a"];
    NSString *strTime = [dateFormatter stringFromDate:date];
    
    return strTime;
}

+ (NSString*)getStringFromDateWithMonth:(NSDate*)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM dd, yyyy"];
    
    NSString *strDate = [dateFormatter stringFromDate:date];
    
    return strDate;
}

+ (NSString*)getDiffrenceBetweenDates:(NSDate*)date1 date2:(NSDate*)date2 {
    
    NSTimeInterval seconds = [date2 timeIntervalSinceDate:date1];
    
    NSInteger days = (int) (floor(seconds / (3600 * 24)));
    if(days) seconds -= days * 3600 * 24;
    
    NSInteger hours = (int) (floor(seconds / 3600));
    if(hours) seconds -= hours * 3600;
    
    NSInteger minutes = (int) (floor(seconds / 60));
    if(minutes) seconds -= minutes * 60;
    
    NSString *strDuration = [NSString stringWithFormat:@"%ld days, %ld hours, %ld minutes",(long)days,(long)hours,(long)minutes];
    
    return strDuration;
}

+ (NSDate*)getDateByRemovingSecond:(NSDate*)date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm a"];
    
    NSString *strDate = [dateFormatter stringFromDate:date];
    
    NSDate *dateFinal = [dateFormatter dateFromString:strDate];
    
    return dateFinal;
}

+ (void)printDate:(NSDate*)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    //[dateFormatter setTimeZone:destinationTimeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm z"];
    
    NSString *strDate = [dateFormatter stringFromDate:date];
    
    NSLog(@"date == %@",strDate);
}

+ (NSDate*)getDateByRemovingTime:(NSDate*)date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *strDate = [dateFormatter stringFromDate:date];
    
    NSDate *dateFinal = [dateFormatter dateFromString:strDate];
    
    return dateFinal;
}

+ (BOOL)isTodayDate:(NSDate*)date{
    
    date = [Helper_OBJ getDateByRemovingTime:date];
    
    NSDate *today = NSDate.date;
    
    NSDate* dateOnly = [Helper_OBJ getDateByRemovingTime:today];
    
    BOOL flag = false;
    
    if([date compare:dateOnly] == NSOrderedSame){
        
        flag = true;
    }
    
    return flag;
}

// MARK:- GET SIZE OF TEXT
+ (CGSize)findHeightForText:(NSString *)text havingWidth:(CGFloat)widthValue andFont:(UIFont *)font {
    CGSize size = CGSizeZero;
    if (text) {
        CGRect frame = [text boundingRectWithSize:CGSizeMake(widthValue, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:font } context:nil];
        size = CGSizeMake(frame.size.width, frame.size.height);
    }
    return size;
}

// MARK:- Get Mobile number in US Format
+ (NSString*)getMobileNumberInUSFormat:(NSString*)strNumber{
    
    NSString *str = [NSString stringWithFormat:@"%@-%@-%@", [strNumber substringToIndex:3], [strNumber substringWithRange:NSMakeRange(3, 3)], [strNumber substringFromIndex:6]];
    
    return str;
}

//to scale images without changing aspect ratio
+ (UIImage*)resizeImage:(UIImage*)image withWidth:(CGFloat)width withHeight:(CGFloat)height
{
    CGSize newSize = CGSizeMake(width, height);
    CGFloat widthRatio = newSize.width/image.size.width;
    CGFloat heightRatio = newSize.height/image.size.height;
    
    if(widthRatio > heightRatio)
    {
        newSize=CGSizeMake(image.size.width*heightRatio,image.size.height*heightRatio);
    }
    else
    {
        newSize=CGSizeMake(image.size.width*widthRatio,image.size.height*widthRatio);
    }
    
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (BOOL)validateEmail:(NSString *)inputText {
    NSString *emailRegex = @"[A-Z0-9a-z][A-Z0-9a-z._%+-]*@[A-Za-z0-9][A-Za-z0-9.-]*\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    NSRange aRange;
    if([emailTest evaluateWithObject:inputText]) {
        aRange = [inputText rangeOfString:@"." options:NSBackwardsSearch range:NSMakeRange(0, [inputText length])];
        NSInteger indexOfDot = aRange.location;
        //NSLog(@"aRange.location:%d - %d",aRange.location, indexOfDot);
        if(aRange.location != NSNotFound) {
            NSString *topLevelDomain = [inputText substringFromIndex:indexOfDot];
            topLevelDomain = [topLevelDomain lowercaseString];
            //NSLog(@"topleveldomains:%@",topLevelDomain);
            NSSet *TLD;
            TLD = [NSSet setWithObjects:@".aero", @".asia", @".biz", @".cat", @".com", @".coop", @".edu", @".gov", @".info", @".int", @".jobs", @".mil", @".mobi", @".museum", @".name", @".net", @".org", @".pro", @".tel", @".travel", @".ac", @".ad", @".ae", @".af", @".ag", @".ai", @".al", @".am", @".an", @".ao", @".aq", @".ar", @".as", @".at", @".au", @".aw", @".ax", @".az", @".ba", @".bb", @".bd", @".be", @".bf", @".bg", @".bh", @".bi", @".bj", @".bm", @".bn", @".bo", @".br", @".bs", @".bt", @".bv", @".bw", @".by", @".bz", @".ca", @".cc", @".cd", @".cf", @".cg", @".ch", @".ci", @".ck", @".cl", @".cm", @".cn", @".co", @".cr", @".cu", @".cv", @".cx", @".cy", @".cz", @".de", @".dj", @".dk", @".dm", @".do", @".dz", @".ec", @".ee", @".eg", @".er", @".es", @".et", @".eu", @".fi", @".fj", @".fk", @".fm", @".fo", @".fr", @".ga", @".gb", @".gd", @".ge", @".gf", @".gg", @".gh", @".gi", @".gl", @".gm", @".gn", @".gp", @".gq", @".gr", @".gs", @".gt", @".gu", @".gw", @".gy", @".hk", @".hm", @".hn", @".hr", @".ht", @".hu", @".id", @".ie", @" No", @".il", @".im", @".in", @".io", @".iq", @".ir", @".is", @".it", @".je", @".jm", @".jo", @".jp", @".ke", @".kg", @".kh", @".ki", @".km", @".kn", @".kp", @".kr", @".kw", @".ky", @".kz", @".la", @".lb", @".lc", @".li", @".lk", @".lr", @".ls", @".lt", @".lu", @".lv", @".ly", @".ma", @".mc", @".md", @".me", @".mg", @".mh", @".mk", @".ml", @".mm", @".mn", @".mo", @".mp", @".mq", @".mr", @".ms", @".mt", @".mu", @".mv", @".mw", @".mx", @".my", @".mz", @".na", @".nc", @".ne", @".nf", @".ng", @".ni", @".nl", @".no", @".np", @".nr", @".nu", @".nz", @".om", @".pa", @".pe", @".pf", @".pg", @".ph", @".pk", @".pl", @".pm", @".pn", @".pr", @".ps", @".pt", @".pw", @".py", @".qa", @".re", @".ro", @".rs", @".ru", @".rw", @".sa", @".sb", @".sc", @".sd", @".se", @".sg", @".sh", @".si", @".sj", @".sk", @".sl", @".sm", @".sn", @".so", @".sr", @".st", @".su", @".sv", @".sy", @".sz", @".tc", @".td", @".tf", @".tg", @".th", @".tj", @".tk", @".tl", @".tm", @".tn", @".to", @".tp", @".tr", @".tt", @".tv", @".tw", @".tz", @".ua", @".ug", @".uk", @".us", @".uy", @".uz", @".va", @".vc", @".ve", @".vg", @".vi", @".vn", @".vu", @".wf", @".ws", @".ye", @".yt", @".za", @".zm", @".zw", nil];
            if(topLevelDomain != nil && ([TLD containsObject:topLevelDomain])) {
                //NSLog(@"TLD contains topLevelDomain:%@",topLevelDomain);
                return TRUE;
            }
            /*else {
             NSLog(@"TLD DOEST NOT contains topLevelDomain:%@",topLevelDomain);
             }*/
            
        }
    }
    return FALSE;
}

@end
