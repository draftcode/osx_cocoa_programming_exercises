//
//  PeopleView.m
//  RaiseMan
//
//  Created by Masaya Suzuki on 11/10/28.
//  Copyright 2011年 Tokyo Institute of Technology. All rights reserved.
//

#import "PeopleView.h"
#import "Person.h"

@implementation PeopleView

- (id)initWithPeople:(NSArray *)persons
{
    [super initWithFrame:NSMakeRect(0, 0, 700, 700)];
    people = [persons copy];
    attributes = [[NSMutableDictionary alloc] init];
    NSFont *font = [NSFont fontWithName:@"Monaco" size:12.0];
    lineHeight = [font capHeight] * 1.7;
    [attributes setObject:font forKey:NSFontAttributeName];
    return self;
}

- (void)dealloc
{
    [people release];
    [attributes release];
    [super dealloc];
}

#pragma mark Pagination

- (BOOL)knowsPageRange:(NSRangePointer)range
{
    NSPrintOperation *po = [NSPrintOperation currentOperation];
    NSPrintInfo *printInfo = [po printInfo];
    
    pageRect = [printInfo imageablePageBounds];
    NSRect newFrame;
    newFrame.origin = NSZeroPoint;
    newFrame.size = [printInfo paperSize];
    [self setFrame:newFrame];
    
    // Reserve one line for page number.
    linesPerPage = pageRect.size.height / lineHeight - 1;
    
    range->location = 1;
    
    range->length = [people count] / linesPerPage;
    if ([people count] % linesPerPage) {
        range->length = range->length + 1;
    }
    return YES;
}

- (NSRect) rectForPage:(NSInteger)page
{
    currentPage = page - 1;
    
    return pageRect;
}

#pragma mark Drawing

- (BOOL)isFlipped
{
    return YES;
}

-(void)drawRect:(NSRect)dirtyRect
{
    NSRect nameRect;
    NSRect raiseRect;
    raiseRect.size.height = nameRect.size.height = lineHeight;
    nameRect.origin.x = pageRect.origin.x;
    nameRect.size.width = 200.0;
    raiseRect.origin.x = NSMaxX(nameRect);
    raiseRect.size.width = 100.0;
    
    for (int i = 0; i < linesPerPage; i++) {
        int index = (currentPage * linesPerPage) + i;
        if (index >= [people count]) {
            break;
        }
        Person *p = [people objectAtIndex:index];
        
        nameRect.origin.y = pageRect.origin.y + (i * lineHeight);
        NSString *nameString = [NSString stringWithFormat:@"%2d %@",
                                index, [p personName]];
        [nameString drawInRect:nameRect withAttributes:attributes];
        
        raiseRect.origin.y = nameRect.origin.y;
        NSString *raiseString = [NSString stringWithFormat:@"%4.1f%%",
                                 [p expectedRaise]];
        [raiseString drawInRect:raiseRect withAttributes:attributes];
    }
    
    NSRect pageNumberRect;
    pageNumberRect.origin.y = pageRect.origin.y + (linesPerPage * lineHeight);
    pageNumberRect.size.width = 20.0;
    pageNumberRect.size.height = lineHeight;
    pageNumberRect.origin.x = (pageRect.size.width - pageNumberRect.size.width)/2;
    // currentPage is zero-origin, so we adjust it to one-origin.
    NSString *pageNumberString = [NSString stringWithFormat:@"%2d", currentPage+1];
    [pageNumberString drawInRect:pageNumberRect withAttributes:attributes];
}
@end
