//
//  Employee.h
//  Departments
//
//  Created by Masaya Suzuki on 11/10/28.
//  Copyright (c) 2011年 Tokyo Institute of Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Department;

@interface Employee : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastname;
@property (nonatomic, retain) Department *department;
@property (readonly) NSString *fullName;

@end
