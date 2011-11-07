//
//  MyDocument.h
//  Departments
//
//  Created by Masaya Suzuki on 11/10/28.
//  Copyright 2011年 Tokyo Institute of Technology. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class ManagingViewController;

@interface MyDocument : NSPersistentDocument
{
    IBOutlet NSBox *box;
    IBOutlet NSPopUpButton *popUp;
    NSMutableArray *viewControllers;
}

- (IBAction)changeViewController:(id)sender;
- (void)displayViewController:(ManagingViewController *)vc;
@end
