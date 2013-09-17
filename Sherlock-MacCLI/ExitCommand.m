//
//  ExitCommand.m
//  Sherlock-MacCLI
//
//  Created by Soheil Rashidi on 9/17/13.
//  Copyright (c) 2013 Soheil Rashidi. All rights reserved.
//

#import "Console.h"
#import "ExitCommand.h"

@implementation ExitCommand

- (void)execute
{
    if (self.context.isDirty)
    {
        while (YES)
        {
            [Console write:@"You have unsaved chanages. Discard them (yes/no)? "];

            NSString* answer = [Console read];

            if ([answer isEqualToString:@"yes"] || [answer isEqualToString:@"y"])
                break;

            if ([answer isEqualToString:@"no"] || [answer isEqualToString:@"n"])
                return;
        }
    }

    self.controller.shouldExit = YES;
}

+ (NSString*)name
{
    return @"exit";
}

+ (NSString*)description
{
    return @"Quit.";
}

@end
