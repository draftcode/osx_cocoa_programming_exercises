//
//  Person.h
//  OldRaiseMan
//
//  Created by Masaya Suzuki on 11/10/23.
//  Copyright 2011年 Tokyo Institute of Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject
{
    NSString *personName;
    float expectedRaise;
}
@property (readwrite, copy) NSString *personName;
@property (readwrite) float expectedRaise;
@end
