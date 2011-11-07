//
//  Department.m
//  Departments
//
//  Created by Masaya Suzuki on 11/10/28.
//  Copyright (c) 2011年 Tokyo Institute of Technology. All rights reserved.
//

#import "Department.h"
#import "Employee.h"


@implementation Department
@dynamic deptName;
@dynamic employees;
@dynamic manager;

- (void)addEmployeesObject:(NSManagedObject *)value
{
    NSLog(@"Dept %@ adding employee %@", [self deptName], [value fullName]);
    NSSet *s = [NSSet setWithObject:value];
    [self willChangeValueForKey:@"employees"
     withSetMutation:NSKeyValueUnionSetMutation
                   usingObjects:s];
    [[self primitiveValueForKey:@"employees"] addObject:value];
    [self didChangeValueForKey:@"employees"
               withSetMutation:NSKeyValueUnionSetMutation
                  usingObjects:s];
}

- (void)removeEmployeesObject:(NSManagedObject *)value
{
    NSLog(@"Dept %@ removing employee %@", [self deptName], [value fullName]);
    Employee *manager = [self manager];
    if (manager == value) {
        [self setManager:nil];
    }
    NSSet *s = [NSSet setWithObject:value];
    [self willChangeValueForKey:@"employees"
                withSetMutation:NSKeyValueMinusSetMutation
                   usingObjects:s];
    [[self primitiveValueForKey:@"employees"] removeObject:value];
    [self didChangeValueForKey:@"employees"
               withSetMutation:NSKeyValueMinusSetMutation
                  usingObjects:s];
}

@end
