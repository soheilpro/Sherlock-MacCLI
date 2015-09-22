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
            NSString* answer = [Console read:@"You have unsaved chanages. What to do? (save/discard/cancel)? " completor:^NSArray *(NSString* buffer, NSString* prefix)
            {
                return @[@"save", @"discard", @"cancel"];
            }];

            if ([answer isEqualToString:@"save"] || [answer isEqualToString:@"s"]) {
                [[self.context.database data] writeToFile:self.context.databasePath atomically:YES];
                break;
            }
            else if ([answer isEqualToString:@"discard"] || [answer isEqualToString:@"d"])
            {
                break;
            }
            else if ([answer isEqualToString:@"cancel"] || [answer isEqualToString:@"c"])
            {
                return;
            }
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
