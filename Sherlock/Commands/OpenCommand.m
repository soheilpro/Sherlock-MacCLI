//
//  OpenCommand.m
//  Sherlock-MacCLI
//
//  Created by Soheil Rashidi on 9/22/15.
//  Copyright © 2015 Soheil Rashidi. All rights reserved.
//

#import "Folder+Utilities.h"
#import "OpenCommand.h"
#import <AppKit/AppKit.h>

@implementation OpenCommand

- (void)execute
{
    PKToken* itemToken = [self.tokenizer nextToken];

    Item* item = [self.context.folder itemForToken:itemToken];

    if (item == nil)
    {
        [self.controller reportError:@"Invalid parameter"];
        return;
    }

    NSURL* url = [NSURL URLWithString:item.value];

    [[NSWorkspace sharedWorkspace] openURL:url];
}

+ (NSArray*)names
{
    return @[@"open"];
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
    return @"Opens item's value.";
}

@end
