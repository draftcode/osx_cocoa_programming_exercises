//
//  MyDocument.m
//  Departments
//
//  Created by Masaya Suzuki on 11/10/28.
//  Copyright 2011年 Tokyo Institute of Technology. All rights reserved.
//

#import "MyDocument.h"
#import "DepartmentViewController.h"
#import "EmployeeViewController.h"

@implementation MyDocument

- (id)init
{
    self = [super init];
    if (self) {
        viewControllers = [[NSMutableArray alloc] init];
        
        ManagingViewController *vc;
        vc = [[DepartmentViewController alloc] init];
        [vc setManagedObjectContext:[self managedObjectContext]];
        [viewControllers addObject:vc];
        [vc release];
        
        vc = [[EmployeeViewController alloc] init];
        [vc setManagedObjectContext:[self managedObjectContext]];
        [viewControllers addObject:vc];
        [vc release];
    }
    return self;
}

- (void)dealloc
{
    [viewControllers release];
    [super dealloc];
}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"MyDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    NSMenu *menu = [popUp menu];
    NSInteger itemCount = [viewControllers count];
    
    for (int i = 0; i < itemCount; i++) {
        NSViewController *vc = [viewControllers objectAtIndex:i];
        NSMenuItem *mi =
            [[NSMenuItem alloc] initWithTitle:[vc title]
                                       action:@selector(changeViewController:)
                                keyEquivalent:@""];
        [mi setTag:i];
        [menu addItem:mi];
        [mi release];
    }
    
    [self displayViewController:[viewControllers objectAtIndex:0]];
    [popUp selectItemAtIndex:0];
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (void)displayViewController:(ManagingViewController *)vc
{
    NSWindow *w = [box window];
    BOOL ended = [w makeFirstResponder:w];
    if (!ended) {
        NSBeep();
        return;
    }
    NSView *v = [vc view];
    
    NSSize currentSize = [[box contentView] frame].size;
    NSSize newSize = [v frame].size;
    float deltaWidth = newSize.width - currentSize.width;
    float deltaHeight = newSize.height - currentSize.height;
    NSRect windowFrame = [w frame];
    windowFrame.size.height += deltaHeight;
    windowFrame.origin.y -= deltaHeight;
    windowFrame.size.width += deltaWidth;
    
    [box setContentView:nil];
    [w setFrame:windowFrame
        display:YES
        animate:YES];
    [box setContentView:v];
    
    [v setNextResponder:vc];
    [vc setNextResponder:box];
}

- (IBAction)changeViewController:(id)sender
{
    NSInteger i = [sender tag];
    ManagingViewController *vc = [viewControllers objectAtIndex:i];
    [self displayViewController:vc];
}

@end
