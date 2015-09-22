//
//  AddItemCommand.m
//  Sherlock-MacCLI
//
//  Created by Soheil Rashidi on 9/17/13.
//  Copyright (c) 2013 Soheil Rashidi. All rights reserved.
//

#import "AddItemCommand.h"
#import "PKToken+Value.h"

@implementation AddItemCommand

- (void)execute
{
    PKToken* nameToken = [self.tokenizer nextToken];
    PKToken* valueToken = [self.tokenizer nextToken];

    if (nameToken == [PKToken EOFToken])
    {
        [self.controller reportError:@"Missing item name"];
        return;
    }

    if (valueToken == [PKToken EOFToken])
    {
        [self.controller reportError:@"Missing item value"];
        return;
    }

    Item* item = [[Item alloc] init];
    item.name = nameToken.unquotedStringValue;
    item.value = valueToken.unquotedStringValue;
    item.parent = self.context.folder;
    item.database = self.context.database;

    PKToken* optionToken = [self.tokenizer nextToken];

    if (optionToken != [PKToken EOFToken] && [optionToken.stringValue isEqualToString:@"--secret"])
        item.isSecret = YES;

    [self.context.folder.items addObject:item];
    [self.context.folder.items sortUsingComparator:[Item sortingComparator]];

    self.context.isDirty = YES;
}

+ (NSArray*)names
{
    return @[@"add"];
}

+ (NSString*)syntax
{
    return @"name value [--secret]";
}

+ (NSArray*)arguments
{
    return @[
        @"name: Item's name.",
        @"value: Item's value.",
        @"--secret: Is it secret?",
    ];
}

+ (NSString*)description
{
    return @"Add a new item.";
}

+ (void)initTokenizer:(PKTokenizer*)tokenizer
{
    [tokenizer.symbolState add:@"--secret"];
}

@end
