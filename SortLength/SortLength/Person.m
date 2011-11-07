//
//  Person.m
//  SortLength
//
//  Created by Masaya Suzuki on 11/10/22.
//  Copyright 2011年 Tokyo Institute of Technology. All rights reserved.
//

#import "Person.h"

@implementation Person

- (id)init
{
    self = [super init];
    if (self) {
        name = @"New Person";
    }
    
    return self;
}

@synthesize name;
@end
