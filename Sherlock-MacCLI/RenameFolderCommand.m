//
//  RenameFolderCommand.m
//  Sherlock-MacCLI
//
//  Created by Soheil Rashidi on 9/17/13.
//  Copyright (c) 2013 Soheil Rashidi. All rights reserved.
//

#import "Folder+Utilities.h"
#import "PKToken+Value.h"
#import "RenameFolderCommand.h"

@implementation RenameFolderCommand

- (void)execute
{
    PKToken* folderToken = [self.tokenizer nextToken];

    Folder* folder = [self.context.folder folderForToken:folderToken];

    if (folder == nil)
    {
        [self.controller reportError:@"Invalid parameter (folder)"];
        return;
    }

    if (folder == self.context.database.root)
    {
        [self.controller reportError:@"Cannot rename root folder."];
        return;
    }

    PKToken* nameToken = [self.tokenizer nextToken];

    if (nameToken == [PKToken EOFToken])
    {
        [self.controller reportError:@"Invalid parameter (name)"];
        return;
    }

    folder.name = nameToken.unquotedStringValue;

    self.context.isDirty = YES;
}

+ (NSString*)name
{
    return @"mvfolder";
}

+ (NSString*)syntax
{
    return @"folder name";
}

+ (NSArray*)arguments
{
    return @[
        @"folder: Folder's name or index.",
        @"name: Folder's new name.",
    ];
}

+ (NSString*)description
{
    return @"Rename folder.";
}

+ (void)initTokenizer:(PKTokenizer*)tokenizer
{
    [tokenizer.symbolState add:@".."];
}

@end
