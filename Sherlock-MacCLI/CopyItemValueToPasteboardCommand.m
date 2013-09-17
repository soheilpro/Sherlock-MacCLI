//
//  CopyItemValueToPasteboardCommand.m
//  Sherlock-MacCLI
//
//  Created by Soheil Rashidi on 9/17/13.
//  Copyright (c) 2013 Soheil Rashidi. All rights reserved.
//

#import "CopyItemValueToPasteboardCommand.h"
#import "Folder+Utilities.h"
#import <AppKit/AppKit.h>

@implementation CopyItemValueToPasteboardCommand

- (void)execute
{
    PKToken* itemToken = [self.tokenizer nextToken];

    Item* item = [self.context.folder itemForToken:itemToken];

    if (item == nil)
    {
        [self.controller reportError:@"Invalid parameter"];
        return;
    }

    NSPasteboard* pasteboard =  [NSPasteboard generalPasteboard];
    [pasteboard clearContents];
    [pasteboard writeObjects:@[item.value]];
}

+ (NSString*)name
{
    return @"pb";
}

+ (NSString*)description
{
    return @"Copy item's value to pasteboard.";
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

@end
