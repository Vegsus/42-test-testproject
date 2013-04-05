//
//  DateConverter.m
//  TestApp
//
//  Created by Eugene Vegner on 05.04.13.
//  Copyright (c) 2013 Eugeny Vegner. All rights reserved.
//

#import "DateConverter.h"

@implementation DateConverter

+ (NSString *)convertDateToString:(NSDate *)date withFormat:(NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter new] autorelease];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:date];
}


@end
