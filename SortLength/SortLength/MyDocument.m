//
//  MyDocument.m
//  SortLength
//
//  Created by Masaya Suzuki on 11/10/22.
//  Copyright 2011年 Tokyo Institute of Technology. All rights reserved.
//

#import "MyDocument.h"

@implementation MyDocument

- (id)init
{
    self = [super init];
    if (self) {
        contents = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [contents dealloc];
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
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (void)setContents:(NSMutableArray *)a
{
    if (a == contents)
        return;
    
    [a retain];
    [contents release];
    contents = a;
}

@end
