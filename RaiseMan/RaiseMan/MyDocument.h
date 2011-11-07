//
//  MyDocument.h
//  RaiseMan
//
//  Created by Masaya Suzuki on 11/10/21.
//  Copyright 2011年 Tokyo Institute of Technology. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class Person;

@interface MyDocument : NSDocument
{
    NSMutableArray *employees;
    IBOutlet NSTableView *tableView;
    IBOutlet NSArrayController *employeeController;
}
- (IBAction)createEmployee:(id)sender;
- (void)setEmployees:(NSMutableArray *)a;
- (void)removeObjectFromEmployeesAtIndex:(NSUInteger)index;
- (void)insertObject:(Person *)p inEmployeesAtIndex:(NSUInteger)index;
- (void)startObservingPerson:(Person *)person;
- (void)stopObservingPerson:(Person *)person;
- (void)changeKeyPath:(NSString *)keyPath ofObject:(id)obj toValue:(id)newValue;
- (IBAction)removeEmployee:(id)sender;
@end
