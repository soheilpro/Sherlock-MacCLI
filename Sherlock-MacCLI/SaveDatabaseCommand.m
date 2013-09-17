//
//  SaveCommand.m
//  Sherlock-MacCLI
//
//  Created by Soheil Rashidi on 9/17/13.
//  Copyright (c) 2013 Soheil Rashidi. All rights reserved.
//

#import "SaveDatabaseCommand.h"

@implementation SaveDatabaseCommand

- (void)execute
{
    NSData* data = [self.context.database data];

    [data writeToFile:self.context.databasePath atomically:YES];

    self.context.isDirty = NO;
}

+ (NSString*)name
{
    return @"save";
}

+ (NSString*)description
{
    return @"Save database.";
}

@end
