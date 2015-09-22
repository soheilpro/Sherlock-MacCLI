//
//  RenameItemCommand.m
//  Sherlock-MacCLI
//
//  Created by Soheil Rashidi on 9/17/13.
//  Copyright (c) 2013 Soheil Rashidi. All rights reserved.
//

#import "Folder+Utilities.h"
#import "PKToken+Value.h"
#import "RenameItemCommand.h"

@implementation RenameItemCommand

- (void)execute
{
    PKToken* itemToken = [self.tokenizer nextToken];

    Item* item = [self.context.folder itemForToken:itemToken];

    if (item == nil)
    {
        [self.controller reportError:@"Invalid parameter (item)"];
        return;
    }

    PKToken* nameToken = [self.tokenizer nextToken];

    if (nameToken == [PKToken EOFToken])
    {
        [self.controller reportError:@"Invalid parameter (name)"];
        return;
    }

    item.name = nameToken.unquotedStringValue;

    self.context.isDirty = YES;
}

+ (NSArray*)names
{
    return @[@"mv"];
}


+ (NSString*)syntax
{
    return @"item name";
}

+ (NSArray*)arguments
{
    return @[
        @"item: Item's name or index.",
        @"name: Item's new name.",
    ];
}

+ (NSString*)description
{
    return @"Rename item.";
}

@end
