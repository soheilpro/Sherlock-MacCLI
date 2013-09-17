//
//  UpdateItemCommand.m
//  Sherlock-MacCLI
//
//  Created by Soheil Rashidi on 9/17/13.
//  Copyright (c) 2013 Soheil Rashidi. All rights reserved.
//

#import "Folder+Utilities.h"
#import "PKToken+Value.h"
#import "UpdateItemCommand.h"

@implementation UpdateItemCommand

- (void)execute
{
    PKToken* itemToken = [self.tokenizer nextToken];

    Item* item = [self.context.folder itemForToken:itemToken];

    if (item == nil)
    {
        [self.controller reportError:@"Invalid parameter (item)"];
        return;
    }

    PKToken* valueToken = [self.tokenizer nextToken];

    if (valueToken == [PKToken EOFToken])
    {
        [self.controller reportError:@"Invalid parameter (value)"];
        return;
    }

    item.value = valueToken.unquotedStringValue;

    self.context.isDirty = YES;
}

+ (NSString*)name
{
    return @"update";
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
    return @"Update item.";
}

@end
