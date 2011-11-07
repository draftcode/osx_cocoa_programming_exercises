//
//  DepartmentViewController.m
//  Departments
//
//  Created by Masaya Suzuki on 11/10/28.
//  Copyright 2011年 Tokyo Institute of Technology. All rights reserved.
//

#import "DepartmentViewController.h"

@implementation DepartmentViewController

- (id)init
{
    self = [super initWithNibName:@"DepartmentView" bundle:nil];
    if (self) {
        [self setTitle:@"Departments"];
    }
    
    return self;
}

@end
