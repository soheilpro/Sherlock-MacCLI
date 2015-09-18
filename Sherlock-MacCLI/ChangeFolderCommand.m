//
//  ChangeFolderCommand.m
//  Sherlock-MacCLI
//
//  Created by Soheil Rashidi on 9/17/13.
//  Copyright (c) 2013 Soheil Rashidi. All rights reserved.
//

#import "ChangeFolderCommand.h"
#import "Folder+Utilities.h"

@implementation ChangeFolderCommand

- (void)execute
{
    PKToken* folderToken = [self.tokenizer nextToken];

    Folder* folder = [self.context.folder folderForToken:folderToken];

    if (folder == nil)
    {
        [self.controller reportError:@"Invalid parameter"];
        return;
    }

    self.context.folder = folder;
}

+ (NSArray*)names
{
    return @[@"cd"];
}

+ (NSString*)syntax
{
    return @"(folder | .. | /)";
}

+ (NSArray*)arguments
{
    return @[
        @"folder: Folder's name or index.",
        @"..: Parent folder.",
        @"/: Root folder.",
    ];
}

+ (NSString*)description
{
    return @"Change folder.";
}

+ (void)initTokenizer:(PKTokenizer*)tokenizer
{
    [tokenizer.symbolState add:@".."];
}

@end
