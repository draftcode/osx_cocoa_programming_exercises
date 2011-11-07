//
//  MyDocument.m
//  DrawOval
//
//  Created by Masaya Suzuki on 11/10/24.
//  Copyright 2011年 Tokyo Institute of Technology. All rights reserved.
//

#import "MyDocument.h"
#import "OvalDrawView.h"

@implementation MyDocument

- (id)init
{
    self = [super init];
    if (self) {
        ovals = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [view unbind:@"value"];
}

- (NSString *)windowNibName
{
    return @"MyDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    [view bind:@"value" toObject:self withKeyPath:@"ovals" options:NULL];

}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    return [NSKeyedArchiver archivedDataWithRootObject:ovals];
}

- (BOOL)readFromData:(NSData *)data
              ofType:(NSString *)typeName
               error:(NSError **)outError
{
    NSMutableArray *newArray = nil;
    @try {
        newArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    @catch (NSException *exception) {
        if (outError) {
            NSDictionary *d = [NSDictionary
                               dictionaryWithObject:@"The data is corrupted."
                               forKey:NSLocalizedFailureReasonErrorKey];
            *outError = [NSError errorWithDomain:NSOSStatusErrorDomain
                                            code:unimpErr
                                        userInfo:d];
        }
        return NO;
    }
    
    [self setOvals:newArray];
    return YES;
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (void)removeObjectFromOvalsAtIndex:(NSUInteger)index
{
    NSValue *v = [ovals objectAtIndex:index];
    NSUndoManager *undo = [self undoManager];
    [[undo prepareWithInvocationTarget:self]
     insertObject:v inOvalsAtIndex:index];
    
    if (![undo isUndoing]) {
        [undo setActionName:@"Delete Oval"];
    }
    
    [ovals removeObjectAtIndex:index];
    
}

- (void)insertObject:(NSValue *)object inOvalsAtIndex:(NSUInteger)index
{
    NSUndoManager *undo = [self undoManager];
    [[undo prepareWithInvocationTarget:self]
     removeObjectFromOvalsAtIndex:index];
    if (![undo isUndoing]) {
        [undo setActionName:@"Insert Oval"];
    }
    
    [ovals insertObject:object atIndex:index];
}

@synthesize ovals;
@end
