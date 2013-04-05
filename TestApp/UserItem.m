//
//  UserItem.m
//  TestApp
//
//  Created by Eugene Vegner on 05.04.13.
//  Copyright (c) 2013 Eugeny Vegner. All rights reserved.
//

#import "UserItem.h"

@implementation UserItem


- (void)dealloc {
    [super dealloc];
}

- (NSString *)fullName {
    _fullName  = [NSString stringWithFormat:@"%@ %@",self.surname,self.name];
    return _fullName;
}

@end
