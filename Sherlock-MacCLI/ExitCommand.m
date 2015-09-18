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
            NSString* answer = [Console read:@"You have unsaved chanages. Discard them (yes/no)? " completor:^NSArray *(NSString* buffer, NSString* prefix)
            {
                return @[@"yes", @"no"];
            }];

            if ([answer isEqualToString:@"yes"] || [answer isEqualToString:@"y"])
                break;

            if ([answer isEqualToString:@"no"] || [answer isEqualToString:@"n"])
                return;
        }
    }

    self.controller.shouldExit = YES;
}

+ (NSArray*)names
{
    return @[@"exit"];
}

+ (NSString*)description
{
    return @"Quit.";
}

@end
