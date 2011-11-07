//
//  PeopleView.h
//  RaiseMan
//
//  Created by Masaya Suzuki on 11/10/28.
//  Copyright 2011年 Tokyo Institute of Technology. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PeopleView : NSView
{
    NSArray *people;
    NSMutableDictionary *attributes;
    float lineHeight;
    NSRect pageRect;
    int linesPerPage;
    int currentPage;
}

- (id)initWithPeople:(NSArray *)array;
@end
