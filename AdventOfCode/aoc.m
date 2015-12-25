//
//  aoc.m
//  AdventOfCode
//
//  Created by Charlie Schmidt on 12/2/15.
//  Copyright © 2015 Charlie Schmidt. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CommonCrypto/CommonDigest.h>

#import "aoc.h"

#define min(a,b) (a < b ? a : b)

#define max(a,b) (a > b ? a : b)

#define bit_is_on(ba,bn) (((ba) & (1 << bn)) ? YES : NO)
#define set_bit(ba,bn) (ba |= (1 << bn))

@implementation AOC

#include "day1.m"
#include "day2.m"
#include "day3.m"
#include "day4.m"
#include "day5.m"
#include "day6.m"
#include "day7.m"
#include "day8.m"
#include "day9.m"
#include "day10.m"
#include "day11.m"
#include "day12.m"
#include "day13.m"
#include "day14.m"
#include "day15.m"
#include "day16.m"
#include "day17.m"
#include "day18.m"
#include "day19.m"
#include "day20.m"
#include "day21.m"
#include "day22.m"
#include "day23.m"
#include "day24.m"
#include "day25.m"

@end
