//
//  UserItem.h
//  TestApp
//
//  Created by Eugene Vegner on 05.04.13.
//  Copyright (c) 2013 Eugeny Vegner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserItem : NSObject
@property (nonatomic, assign) NSInteger objectId;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *surname;
@property (nonatomic, retain) NSDate *birthDate;
@property (nonatomic, retain) NSString *bio;
@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSString *zip;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) UIImage *avatar;
@property (nonatomic, retain) NSString *fullName;
@end
