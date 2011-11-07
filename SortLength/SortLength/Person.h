//
//  Person.h
//  SortLength
//
//  Created by Masaya Suzuki on 11/10/22.
//  Copyright 2011年 Tokyo Institute of Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject
{
    NSString *name;
}
@property (readwrite, copy) NSString *name;
@end
