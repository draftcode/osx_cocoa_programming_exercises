//
//  MyDocument.h
//  ZIPSpector
//
//  Created by Masaya Suzuki on 11/10/29.
//  Copyright 2011年 Tokyo Institute of Technology. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MyDocument : NSDocument <NSTableViewDataSource>
{
    IBOutlet NSTableView *tableView;
    NSArray *filenames;
}
@end
