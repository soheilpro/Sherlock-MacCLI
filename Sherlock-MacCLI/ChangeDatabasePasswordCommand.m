//
//  ChangeDatabasePasswordCommand.m
//  Sherlock-MacCLI
//
//  Created by Soheil Rashidi on 9/17/13.
//  Copyright (c) 2013 Soheil Rashidi. All rights reserved.
//

#import "ChangeDatabasePasswordCommand.h"
#import "PKToken+Value.h"

@implementation ChangeDatabasePasswordCommand

- (void)execute
{
    PKToken* passwordToken = [self.tokenizer nextToken];

    if (passwordToken == [PKToken EOFToken])
    {
        [self.controller reportError:@"Missing password parameter"];
        return;
    }

    NSString* password = passwordToken.unquotedStringValue;

    if (password.length == 0)
        password = nil;

    self.context.database.password = password;
    self.context.isDirty = YES;
}

+ (NSString*)name
{
    return @"chpwd";
}

+ (NSString*)syntax
{
    return @"password";
}

+ (NSArray*)arguments
{
    return @[
        @"password: New database password.",
    ];
}

+ (NSString*)description
{
    return @"Change database password.";
}

@end
