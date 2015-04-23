//
//  MyProcess.h
//  AMParser
//
//  Created by admin on 4/17/15.
//  Copyright (c) 2015 Zhou, Yuan. All rights reserved.
//

#ifndef AMParser_MyProcess_h
#define AMParser_MyProcess_h


#endif

@interface MyProcess : NSObject
{
    NSString *pid;
    NSString *cpu;
    NSString *pname;
    
    //NSNumber *age;
}

@property(nonatomic, retain) NSString *pid;
@property(nonatomic, retain) NSString *cpu;
@property(nonatomic, retain) NSString *pname;
//@property(nonatomic, retain) NSNumber *age;

@end