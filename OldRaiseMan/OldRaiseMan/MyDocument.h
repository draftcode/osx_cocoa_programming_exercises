//
//  MyDocument.h
//  OldRaiseMan
//
//  Created by Masaya Suzuki on 11/10/23.
//  Copyright 2011年 Tokyo Institute of Technology. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Person.h"

@interface MyDocument : NSDocument <NSTableViewDataSource>
{
    NSMutableArray *employees;
    IBOutlet NSTableView *tableView;
}
- (IBAction)createEmployee:(id)sender;
- (IBAction)deleteSelectedEmployee:(id)sender;
@end
