//
//  Context.h
//  Sherlock-MacCLI
//
//  Created by Soheil Rashidi on 9/17/13.
//  Copyright (c) 2013 Soheil Rashidi. All rights reserved.
//

#import "Database.h"
#import <Foundation/Foundation.h>

@interface Context : NSObject

@property (nonatomic, strong) NSString* databasePath;
@property (nonatomic, strong) Database* database;
@property (nonatomic, strong) Folder* folder;
@property (nonatomic) BOOL isDirty;

@end
