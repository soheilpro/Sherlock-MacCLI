//
//  Command.h
//  Sherlock-MacCLI
//
//  Created by Soheil Rashidi on 9/17/13.
//  Copyright (c) 2013 Soheil Rashidi. All rights reserved.
//

#import "Context.h"
#import "Controller.h"
#import <Foundation/Foundation.h>
#import <ParseKit/ParseKit.h>

@interface Command : NSObject

@property (nonatomic, strong) Context* context;
@property (nonatomic, strong) Controller* controller;
@property (nonatomic, strong) PKTokenizer* tokenizer;

- (void)execute;

+ (NSString*)name;
+ (NSString*)syntax;
+ (NSArray*)arguments;
+ (NSString*)description;
+ (void)initTokenizer:(PKTokenizer*)tokenizer;

@end
