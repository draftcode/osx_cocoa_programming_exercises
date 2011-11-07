//
//  Employee.m
//  Departments
//
//  Created by Masaya Suzuki on 11/10/28.
//  Copyright (c) 2011年 Tokyo Institute of Technology. All rights reserved.
//

#import "Employee.h"
#import "Department.h"


@implementation Employee
@dynamic firstName;
@dynamic lastname;
@dynamic department;

- (NSString *)fullName
{
    NSString *first = [self firstName];
    NSString *last = [self lastName];
    if (!first)
        return last;
    if (!last)
        return first;
    return [NSString stringWithFormat:@"%@ %@", first, last];
}

+ (NSSet *)keyPathsForValuesAffectingFullName
{
    return [NSSet setWithObjects:@"firstName", @"lastName", nil];
}

@end
