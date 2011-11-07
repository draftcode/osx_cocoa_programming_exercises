//
//  EmployeeViewController.m
//  Departments
//
//  Created by Masaya Suzuki on 11/10/28.
//  Copyright 2011年 Tokyo Institute of Technology. All rights reserved.
//

#import "EmployeeViewController.h"

@implementation EmployeeViewController

- (id)init
{
    self = [super initWithNibName:@"EmployeeView" bundle:nil];
    if (self) {
        [self setTitle:@"Employees"];
    }
    
    return self;
}

- (void)keyDown:(NSEvent *)theEvent
{
    if (([theEvent keyCode] == 51) || ([theEvent keyCode] == 117)) {
        [employeeController remove:nil];
    } else {
        [super keyDown:theEvent];
    }
}

@end
