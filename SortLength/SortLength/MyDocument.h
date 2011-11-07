//
//  MyDocument.h
//  SortLength
//
//  Created by Masaya Suzuki on 11/10/22.
//  Copyright 2011年 Tokyo Institute of Technology. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MyDocument : NSPersistentDocument
{
    NSMutableArray *contents;
}
- (void)setContents:(NSMutableArray *)a;
@end
