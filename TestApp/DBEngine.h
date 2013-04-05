//
//  DBEngine.h
//  TestApp
//
//  Created by Eugene Vegner on 05.04.13.
//  Copyright (c) 2013 Eugeny Vegner. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UserItem;

@interface DBEngine : NSObject
+ (DBEngine *)sharedInstance;
- (UserItem *)getUser;

@end
