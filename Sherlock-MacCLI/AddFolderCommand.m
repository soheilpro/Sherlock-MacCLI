//
//  AddFolderCommand.m
//  Sherlock-MacCLI
//
//  Created by Soheil Rashidi on 9/17/13.
//  Copyright (c) 2013 Soheil Rashidi. All rights reserved.
//

#import "AddFolderCommand.h"
#import "PKToken+Value.h"

@implementation AddFolderCommand

-(void)execute
{
    PKToken* nameToken = [self.tokenizer nextToken];

    if (nameToken == [PKToken EOFToken])
    {
        [self.controller reportError:@"Missing name parameter"];
        return;
    }

    Folder* folder = [[Folder alloc] init];
    folder.name = nameToken.unquotedStringValue;
    folder.parent = self.context.folder;
    folder.database = self.context.database;

    [self.context.folder.folders addObject:folder];
    [self.context.folder.folders sortUsingComparator:[Folder sortingComparator]];

    self.context.isDirty = YES;
}

+ (NSArray*)names
{
    return @[@"mkdir"];
}

+ (NSString*)syntax
{
    return @"name";
}

+ (NSArray*)arguments
{
    return @[
        @"name: Folder's name.",
    ];
}

+ (NSString*)description
{
    return @"Add a new folder.";
}

@end
