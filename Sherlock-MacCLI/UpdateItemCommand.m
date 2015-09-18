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

    PKToken* nextToken = [self.tokenizer nextToken];

    if (nextToken == [PKToken EOFToken])
    {
        [self.controller reportError:@"Invalid parameter (value)"];
        return;
    }

    if ([nextToken.stringValue isEqualToString:@"--secret"])
        item.isSecret = YES;

    else if ([nextToken.stringValue isEqualToString:@"--no-secret"])
        item.isSecret = NO;

    else
        item.value = nextToken.unquotedStringValue;

    self.context.isDirty = YES;
}

+ (NSArray*)names
{
    return @[@"update"];
}

+ (NSString*)syntax
{
    return @"item (value | --secret | --no-secret)";
}

+ (NSArray*)arguments
{
    return @[
        @"item: Item's name or index.",
        @"--secret: Secret item.",
        @"--no-secret: Normal item.",
    ];
}

+ (NSString*)description
{
    return @"Update item.";
}

+ (void)initTokenizer:(PKTokenizer*)tokenizer
{
    [tokenizer.symbolState add:@"--secret"];
    [tokenizer.symbolState add:@"--no-secret"];
}

@end
