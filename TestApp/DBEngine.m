//
//  DBEngine.m
//  TestApp
//
//  Created by Eugene Vegner on 05.04.13.
//  Copyright (c) 2013 Eugeny Vegner. All rights reserved.
//

#import "DBEngine.h"
#import "sqlite3.h"
#import "Const.h"
#import "UserItem.h"

@interface DBEngine ()
@property (nonatomic, retain) NSString *sqlRequest;

@end



@implementation DBEngine
@synthesize sqlRequest = _sqlRequest;

- (void)dealloc {
    self.sqlRequest = nil;
    [super dealloc];
}

+ (DBEngine *)sharedInstance {
    static dispatch_once_t once;
    static DBEngine *engine;
    dispatch_once(&once, ^ { engine = [[DBEngine alloc] init]; });
    return engine;
}

#pragma mark - Check database file

- (NSString *)dataFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:DATABASE_FILE];
}

- (void)checkAndCopyFile {
    NSError *error;
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self dataFilePath]]) {
        NSString *filePathBundle = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DATABASE_FILE];
        [[NSFileManager defaultManager] copyItemAtPath:filePathBundle toPath:[self dataFilePath] error:&error];
        NSLog(@"\n- DATABASE: file not found. Copy database file to Documents dir");
    }
    NSLog(@"\n+ DATABASE: file found!");
}

- (UserItem *)getUser {
    self.sqlRequest = @"SELECT user_id, name, surname, address, zip, email, bio, birth_date, avatar FROM user WHERE user_id = 1";
	[self checkAndCopyFile];
    UserItem *user = nil;
	sqlite3 *database;
	if (sqlite3_open([[self dataFilePath] UTF8String], &database) == SQLITE_OK) {
		sqlite3_stmt *statement;
		const char *errormsg;
		if (sqlite3_prepare_v2(database, [self.sqlRequest UTF8String], -1, &statement, &errormsg) == SQLITE_OK) {
            while(sqlite3_step(statement) == SQLITE_ROW) {
                user = [[UserItem new] autorelease];
                user.objectId = sqlite3_column_int(statement, 0);
                user.name = (((char *)sqlite3_column_text(statement, 1)) == nil)?@"":[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                user.surname = (((char *)sqlite3_column_text(statement, 2)) == nil)?@"":[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                user.address = (((char *)sqlite3_column_text(statement, 3)) == nil)?@"":[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                user.zip = (((char *)sqlite3_column_text(statement, 4)) == nil)?@"":[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                user.email = (((char *)sqlite3_column_text(statement, 5)) == nil)?@"":[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                user.bio = (((char *)sqlite3_column_text(statement, 6)) == nil)?@"":[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                user.birthDate = [NSDate dateWithTimeIntervalSince1970:sqlite3_column_double(statement, 7)];
                NSData *dataForCachedImage = [[NSData alloc] initWithBytes:sqlite3_column_blob(statement, 8) length: sqlite3_column_bytes(statement, 8)];
                user.avatar = [UIImage imageWithData:dataForCachedImage];
                [dataForCachedImage release];
            }
        } else {
            NSLog(@"\n- DATABASE: error load sql");
        }
        sqlite3_finalize(statement);
    } else {
        sqlite3_close(database);
        NSAssert1(NO, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
    }
    return user;
}

@end
