//
//  aoc.m
//  AdventOfCode
//
//  Created by Charlie Schmidt on 12/2/15.
//  Copyright © 2015 Charlie Schmidt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "aoc.h"

@implementation AOC


- (void)day1:(NSString*)input
{
    NSInteger len = [input length];
    NSInteger floor = 0;
    NSInteger position = 1;
    NSInteger firstPositionToBasement = -1;
    
    while (position <= len)
    {
        char c = [input characterAtIndex:position - 1];
        
        if (c == ')')
        {
            floor--;
        }
        else if (c == '(')
        {
            floor++;
        }
        
        if (floor == -1 && firstPositionToBasement == -1)
        {
            firstPositionToBasement = position;
        }
        
        position++;
    }
    
    printf("Input: %s\n",[input UTF8String]);
    printf("Final floor: %ld, enters basement at %ld\n",(long)floor, (long)firstPositionToBasement);
    printf("\n");
}

@end
