//
//  TaskListAppDelegate.m
//  TaskList
//
//  Created by Masaya Suzuki on 11/10/21.
//  Copyright 2011年 Tokyo Institute of Technology. All rights reserved.
//

#import "TaskListAppDelegate.h"

@implementation TaskListAppDelegate

- (id)init
{
    self = [super init];
    if (self) {
        todoList = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (IBAction)addItem:(id)sender
{
    NSString *todo = [newItemField stringValue];
    if ([todo length] != 0) {
        [todoList addObject:todo];
        [todoTableView reloadData];
    }
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [todoList count];
}

- (id)tableView:(NSTableView *)tableView
        objectValueForTableColumn:(NSTableColumn *)tableColumn
                              row:(NSInteger)row
{
    return [todoList objectAtIndex:row];
}

- (void)tableView:(NSTableView *)tableView
   setObjectValue:(id)object
   forTableColumn:(NSTableColumn *)tableColumn
              row:(NSInteger)row
{
    if ([object length] == 0) {
        [todoList removeObjectAtIndex:row];
        [todoTableView reloadData];
    } else {
        [todoList replaceObjectAtIndex:row withObject:object];
    }
}
@end
