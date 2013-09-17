//
//  DeleteItemCommand.m
//  Sherlock-MacCLI
//
//  Created by Soheil Rashidi on 9/17/13.
//  Copyright (c) 2013 Soheil Rashidi. All rights reserved.
//

#import "DeleteItemCommand.h"
#import "Folder+Utilities.h"

@implementation DeleteItemCommand

- (void)execute
{
    PKToken* itemToken = [self.tokenizer nextToken];

    Item* item = [self.context.folder itemForToken:itemToken];

    if (item == nil)
    {
        [self.controller reportError:@"Invalid parameter (item)"];
        return;
    }

    [item.parent.folders removeObject:item];

    self.context.isDirty = YES;
}

+ (NSString*)name
{
    return @"rmitem";
}

+ (NSString*)description
{
    return @"Delete item.";
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
