//
//  DateConverter.h
//  TestApp
//
//  Created by Eugene Vegner on 05.04.13.
//  Copyright (c) 2013 Eugeny Vegner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateConverter : NSObject
+ (NSString *)convertDateToString:(NSDate *)date withFormat:(NSString *)format;

@end
