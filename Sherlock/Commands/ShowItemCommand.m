//
//  ShowItemCommand.m
//  Sherlock-MacCLI
//
//  Created by Soheil Rashidi on 9/17/13.
//  Copyright (c) 2013 Soheil Rashidi. All rights reserved.
//

#import "Console.h"
#import "Folder+Utilities.h"
#import "ShowItemCommand.h"

@implementation ShowItemCommand

- (void)execute
{
    PKToken* itemToken = [self.tokenizer nextToken];

    Item* item = [self.context.folder itemForToken:itemToken];

    if (item == nil)
    {
        [self.controller reportError:@"Invalid parameter"];
        return;
    }

    [Console write:@"" COLOR_GREEN "%@" COLOR_RESET "\n", item.value];
}

+ (NSArray*)names
{
    return @[@"show"];
}

+ (NSString*)syntax
{
    return @"item";
}

+ (NSArray*)arguments
{
    return @[
        @"item: Item's name or index.",
    ];
}

+ (NSString*)description
{
    return @"Show item.";
}

@end
