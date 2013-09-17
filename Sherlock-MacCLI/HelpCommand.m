//
//  HelpCommand.m
//  Sherlock-MacCLI
//
//  Created by Soheil Rashidi on 9/17/13.
//  Copyright (c) 2013 Soheil Rashidi. All rights reserved.
//

#import "Console.h"
#import "HelpCommand.h"

@implementation HelpCommand

- (void)execute
{
    for (id commandClass in self.controller.commandClasses)
    {
        [Console write:@"- " COLOR_CYAN "%@" COLOR_RESET " %@\n", [commandClass name], [commandClass syntax]];

        for (NSString* argument in [commandClass arguments])
            [Console write:@"  %@\n", argument];

        [Console write:@"\n"];
    }
}

+ (NSString*)name
{
    return @"help";
}

+ (NSString*)description
{
    return @"Yours truely.";
}

@end
