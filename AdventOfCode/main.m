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
    
    NSArray* lines = [words componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    return lines;
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        AOC *aoc = [[AOC alloc] init];
        NSString *method = @"day1";
        
        NSArray *inputs = getInputsFromFile(method);
        for (NSString *input in inputs)
        {
            if ([input isEqual:@""])
            {
                continue;
            }
            [aoc day1:input];
        }
        
    }
    return 0;
}

