//
//  MyDocument.m
//  ZIPSpector
//
//  Created by Masaya Suzuki on 11/10/29.
//  Copyright 2011年 Tokyo Institute of Technology. All rights reserved.
//

#import "MyDocument.h"

@implementation MyDocument

- (id)init
{
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
        // If an error occurs here, send a [self release] message and return nil.
    }
    return self;
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

- (BOOL)readFromURL:(NSURL *)url ofType:(NSString *)typeName error:(NSError **)outError
{
    NSString *filename = [url path];
    
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath:@"/usr/bin/zipinfo"];
    NSArray *args = [NSArray arrayWithObjects:@"-1", filename, nil];
    [task setArguments:args];
    
    NSPipe *outPipe = [[NSPipe alloc] init];
    [task setStandardOutput:outPipe];
    [outPipe release];
    
    [task launch];
    
    NSData *data = [[outPipe fileHandleForReading] readDataToEndOfFile];
    
    [task waitUntilExit];
    int status = [task terminationStatus];
    [task release];
    
    if (status != 0) {
        if (outError) {
            NSDictionary *eDict =
                [NSDictionary dictionaryWithObject:@"zipinfo failed"
                                            forKey:NSLocalizedFailureReasonErrorKey];
            *outError = [NSError errorWithDomain:NSOSStatusErrorDomain
                                            code:0
                                        userInfo:eDict];
        }
        
        return NO;
    }
    
    NSString *aString = [[NSString alloc] initWithData:data
                                              encoding:NSUTF8StringEncoding];
    
    [filenames release];
    filenames = [[aString componentsSeparatedByString:@"\n"] retain];
    NSLog(@"filenames = %@", filenames);
    
    [aString release];
    
    [tableView reloadData];
    
    return YES;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [filenames count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    return [filenames objectAtIndex:row];
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

@end
