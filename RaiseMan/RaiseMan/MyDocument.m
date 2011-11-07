//
//  MyDocument.m
//  RaiseMan
//
//  Created by Masaya Suzuki on 11/10/21.
//  Copyright 2011年 Tokyo Institute of Technology. All rights reserved.
//

#import "MyDocument.h"
#import "Person.h"
#import "PreferenceController.h"
#import "PeopleView.h"

@implementation MyDocument

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem
{
    if ([menuItem action] == @selector(removeEmployee:)) {
        if ([employees count] == 0) {
            return NO;
        }
    }
    return [super validateMenuItem:menuItem];
}

- (id)init
{
    self = [super init];
    if (self) {
        employees = [[NSMutableArray alloc] init];
        
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self
               selector:@selector(handleColorChange:)
                   name:BNRColorChangedNotification
                 object:nil];
    }
    return self;
}

- (void)dealloc
{
    [self setEmployees:nil];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
    [super dealloc];
}

- (void)setEmployees:(NSMutableArray *)a
{
    if (a == employees)
        return;
    
    for (Person *person in employees) {
        [self stopObservingPerson:person];
    }
    
    [a retain];
    [employees release];
    employees = a;
    for (Person *person in employees) {
        [self startObservingPerson:person];
    }
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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *colorAsData;
    colorAsData = [defaults objectForKey:BNRTableBgColorKey];
    
    [tableView setBackgroundColor:
     [NSKeyedUnarchiver unarchiveObjectWithData:colorAsData]];
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (void)insertObject:(Person *)p inEmployeesAtIndex:(NSUInteger)index
{
    NSUndoManager *undo = [self undoManager];
    [[undo prepareWithInvocationTarget:self]
     removeObjectFromEmployeesAtIndex:index];
    
    if (![undo isUndoing]) {
        [undo setActionName:@"Insert Person"];
    }
    
    [self startObservingPerson: p];
    [employees insertObject:p atIndex:index];
}

- (void)removeObjectFromEmployeesAtIndex:(NSUInteger)index
{
    Person *p = [employees objectAtIndex:index];
    NSUndoManager *undo = [self undoManager];
    [[undo prepareWithInvocationTarget:self] insertObject:p
                                       inEmployeesAtIndex:index];
    
    if (![undo isUndoing]) {
        [undo setActionName:@"Delete Person"];
    }
    
    [self stopObservingPerson: p];
    [employees removeObjectAtIndex:index];
}

- (void)startObservingPerson:(Person *)person
{
    [person addObserver:self
             forKeyPath:@"personName"
                options:NSKeyValueObservingOptionOld
                context:NULL];
    
    [person addObserver:self
             forKeyPath:@"expectedRaise"
                options:NSKeyValueObservingOptionOld
                context:NULL];
}

- (void)stopObservingPerson:(Person *)person
{
    [person removeObserver:self forKeyPath:@"personName"];
    [person removeObserver:self forKeyPath:@"expectedRaise"];
}

- (void)changeKeyPath:(NSString *)keyPath
             ofObject:(id)obj
              toValue:(id)newValue
{
    [obj setValue:newValue forKeyPath:keyPath];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    NSUndoManager *undo = [self undoManager];
    id oldValue = [change objectForKey:NSKeyValueChangeOldKey];
    
    if (oldValue == [NSNull null]) {
        oldValue = nil;
    }
    
    [[undo prepareWithInvocationTarget:self] changeKeyPath:keyPath
                                                  ofObject:object
                                                   toValue:oldValue];
    [undo setActionName:@"Edit"];
}

- (void)createEmployee:(id)sender
{
    NSWindow *w = [tableView window];
    
    BOOL editingEnded = [w makeFirstResponder:w];
    if (!editingEnded) {
        return;
    }
    NSUndoManager *undo = [self undoManager];
    
    if ([undo groupingLevel]) {
        [undo endUndoGrouping];
        [undo beginUndoGrouping];
    }
    
    Person *p = [employeeController newObject];
    
    [employeeController addObject:p];
    [p release];
    [employeeController rearrangeObjects];
    
    NSArray *a = [employeeController arrangedObjects];
    
    NSUInteger row = [a indexOfObjectIdenticalTo:p];
    
    [tableView editColumn:0 row:row withEvent:nil select:YES];
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    [[tableView window] endEditingFor:nil];
    
    return [NSKeyedArchiver archivedDataWithRootObject:employees];
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
    
    [self setEmployees:newArray];
    return YES;
}

- (void)handleColorChange:(NSNotification *)note
{
    NSLog(@"Received notification: %@", note);
    NSColor *color = [[note userInfo] objectForKey:@"color"];
    [tableView setBackgroundColor:color];
}

- (IBAction)removeEmployee:(id)sender
{
    NSArray *selectedPeople = [employeeController selectedObjects];
    NSAlert *alert =
        [NSAlert alertWithMessageText:NSLocalizedString(@"DELETE", @"Delete")
                        defaultButton:NSLocalizedString(@"DELETE", @"Delete")
                      alternateButton:NSLocalizedString(@"CANCEL", @"Cancel")
                          otherButton:nil
            informativeTextWithFormat:
                NSLocalizedString(@"SURE_DELETE",
                                  @"Do you really want to delete %d people?"),
                [selectedPeople count]];
    
    [alert beginSheetModalForWindow:[tableView window]
                      modalDelegate:self
                     didEndSelector:@selector(alertEnded:code:context:)
                        contextInfo:NULL];
}

- (void)alertEnded:(NSAlert *)alert code:(NSInteger)choice context:(void *)v
{
    if (choice == NSAlertDefaultReturn) {
        [employeeController remove:nil];
    }
}

- (IBAction)raiseToZero:(id)sender
{
    NSArray *selectedPeople = [employeeController selectedObjects];
    
    for (Person *person in selectedPeople) {
        person.expectedRaise = 0.0;
    }
}

- (NSPrintOperation *)printOperationWithSettings:(NSDictionary *)printSettings
                                           error:(NSError **)outError
{
    PeopleView *view = [[PeopleView alloc] initWithPeople:employees];
    NSPrintInfo *printInfo = [self printInfo];
    NSPrintOperation *printOp
        = [NSPrintOperation printOperationWithView:view
                                         printInfo:printInfo];
    [view release];
    return printOp;
}

@end
