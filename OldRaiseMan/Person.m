//
//  Person.m
//  OldRaiseMan
//
//  Created by Masaya Suzuki on 11/10/23.
//  Copyright 2011年 Tokyo Institute of Technology. All rights reserved.
//

#import "Person.h"

@implementation Person

- (id)init
{
    self = [super init];
    if (self) {
        expectedRaise = 5.0;
        personName = @"New Person";
    }
    
    return self;
}

- (void)dealloc
{
    [personName release];
    [super dealloc];
}

- (void)setNilValueForKey:(NSString *)key
{
    if ([key isEqual:@"expectedRaise"]) {
        [self setExpectedRaise:0.0];
    } else {
        [super setNilValueForKey:key];
    }
}
@synthesize personName;
@synthesize expectedRaise;
@end
