//
//  main.m
//  AdventOfCode
//
//  Created by Charlie Schmidt on 12/2/15.
//  Copyright © 2015 Charlie Schmidt. All rights reserved.
//

#import <Foundation/Foundation.h>

#include "aoc.h"

NSArray* getInputsFromFile(NSString *method)
{
    NSBundle *appBundle = [NSBundle mainBundle];
    NSString *path = [appBundle pathForResource:method ofType:@"input" inDirectory:@"Inputs"];
    NSError *error = nil;

    NSString *words = [[NSString alloc] initWithContentsOfFile:path
                                                      encoding:NSUTF8StringEncoding error:&error];
    
    NSMutableArray* lines = [[words componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] mutableCopy];
    
    [lines removeObject:@""];
    return lines;
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        AOC *aoc = [[AOC alloc] init];
        NSString *method = @"day19";
        
        NSArray *inputs = getInputsFromFile(method);
        
        SEL dayMethod = NSSelectorFromString([method stringByAppendingString:@":"]);
       
        if ([aoc respondsToSelector:dayMethod])
        {
            IMP imp = [aoc methodForSelector:dayMethod];
            
            void (*func)(id, SEL, NSArray*) = (void *)imp;
            func(aoc,dayMethod,inputs);
        }
        else
        {
            SEL dayPartMethod = NSSelectorFromString([method stringByAppendingString:@":part:"]);
            
            IMP imp = [aoc methodForSelector:dayPartMethod];
            
            void (*func)(id, SEL, NSArray *, NSNumber *) = (void *)imp;
            func(aoc,dayMethod,inputs,@1);
            func(aoc,dayMethod,inputs,@2);
            
        }
    }
    return 0;
}

