//
//  Person.m
//  RaiseMan
//
//  Created by Masaya Suzuki on 11/10/21.
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

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:personName forKey:@"personName"];
    [coder encodeFloat:expectedRaise forKey:@"expectedRaise"];
}

- (id)initWithCoder:(NSCoder *)coder
{
    [super init];
    personName = [[coder decodeObjectForKey:@"personName"] retain];
    expectedRaise = [coder decodeFloatForKey:@"expectedRaise"];
    return self;
}

@synthesize personName;
@synthesize expectedRaise;
@end
