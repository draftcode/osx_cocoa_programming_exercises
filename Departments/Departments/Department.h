//
//  Department.h
//  Departments
//
//  Created by Masaya Suzuki on 11/10/28.
//  Copyright (c) 2011年 Tokyo Institute of Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Department : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * deptName;
@property (nonatomic, retain) NSSet *employees;
@property (nonatomic, retain) NSManagedObject *manager;
@end

@interface Department (CoreDataGeneratedAccessors)

- (void)addEmployeesObject:(NSManagedObject *)value;
- (void)removeEmployeesObject:(NSManagedObject *)value;
// - (void)addEmployees:(NSSet *)values;
// - (void)removeEmployees:(NSSet *)values;

@end
