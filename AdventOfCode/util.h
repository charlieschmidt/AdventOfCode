//
//  util.h
//  AdventOfCode
//
//  Created by Charlie Schmidt on 12/25/15.
//  Copyright © 2015 Charlie Schmidt. All rights reserved.
//

#ifndef util_h
#define util_h

#define min(a,b) (a < b ? a : b)

#define max(a,b) (a > b ? a : b)

#define bit_is_on(ba,bn) (((ba) & (1 << bn)) ? YES : NO)

#define set_bit(ba,bn) (ba |= (1 << bn))

#endif /* util_h */
