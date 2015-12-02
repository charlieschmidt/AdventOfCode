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
        NSString *method = @"day2";
        
        NSArray *inputs = getInputsFromFile(method);
        
        SEL dayMethod = NSSelectorFromString([method stringByAppendingString:@":"]);
       
        [aoc performSelector:dayMethod withObject:inputs];
        
    }
    return 0;
}

