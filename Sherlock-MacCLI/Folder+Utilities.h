//
//  Folder+Utilities.h
//  Sherlock-MacCLI
//
//  Created by Soheil Rashidi on 9/17/13.
//  Copyright (c) 2013 Soheil Rashidi. All rights reserved.
//

#import "Folder.h"
#import "Item.h"
#import <ParseKit/ParseKit.h>

@interface Folder (Utilities)

- (NSString*)path;
- (Folder*)folderForToken:(PKToken*)token;
- (Item*)itemForToken:(PKToken*)token;

@end
