//
//  DeleteFolderCommand.m
//  Sherlock-MacCLI
//
//  Created by Soheil Rashidi on 9/17/13.
//  Copyright (c) 2013 Soheil Rashidi. All rights reserved.
//

#import "DeleteFolderCommand.h"
#import "Folder+Utilities.h"

@implementation DeleteFolderCommand

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
        [self.controller reportError:@"Cannot delete root folder."];
        return;
    }

    [folder.parent.folders removeObject:folder];

    self.context.folder = folder.parent;
    self.context.isDirty = YES;
}

+ (NSArray*)names
{
    return @[@"rmdir"];
}

+ (NSString*)syntax
{
    return @"folder";
}

+ (NSArray*)arguments
{
    return @[
        @"folder: Folder's name or index.",
    ];
}

+ (NSString*)description
{
    return @"Delete folder.";
}

+ (void)initTokenizer:(PKTokenizer*)tokenizer
{
    [tokenizer.symbolState add:@".."];
}

@end
