
- (void)day9:(NSArray *)inputs
{
    NSMutableDictionary *cityToCityToDistance = [[NSMutableDictionary alloc] init];
    NSError *error = nil;

    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(\\w*) to (\\w*) = (\\d*)" options:0 error:&error];
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    
    for (NSString *input in inputs)
    {
        NSArray *matches = [regex matchesInString:input options:0 range:NSMakeRange(0,[input length])];
        for (NSTextCheckingResult *result in matches)
        {
            NSString *sourceCity = [input substringWithRange:[result rangeAtIndex:1]];
            
            NSString *destCity = [input substringWithRange:[result rangeAtIndex:2]];
            NSNumber *distance = [f numberFromString:[input substringWithRange:[result rangeAtIndex:3]]];
            
            NSMutableDictionary *sourceCityDict = [cityToCityToDistance valueForKey:sourceCity];
            if (sourceCityDict == nil)
            {
                sourceCityDict = [[NSMutableDictionary alloc] init];
                [cityToCityToDistance setObject:sourceCityDict forKey:sourceCity];
            }
            
            [sourceCityDict setObject:distance forKey:destCity];
            
            NSMutableDictionary *destCityDict = [cityToCityToDistance valueForKey:destCity];
            if (destCityDict == nil)
            {
                destCityDict = [[NSMutableDictionary alloc] init];
                [cityToCityToDistance setObject:destCityDict forKey:destCity];
            }
            
            [destCityDict setObject:distance forKey:sourceCity];
        }
    }
    
    
    NSMutableArray *paths = [self generatePermutations:[cityToCityToDistance allKeys]];
    int shortestDistance = INT_MAX;
    NSArray *shortestPath;
    int longestDistance = 0;
    NSArray *longestPath;
    for (NSArray *path in paths)
    {
        int pathDistance = 0;
        for (int i = 0; i < [path count]-1; i++)
        {
            NSString *sourceCity = path[i];
            NSString *destCity = path[i+1];
            NSString *pathString = [NSString stringWithFormat:@"%@.%@",sourceCity,destCity];
            NSNumber *distance = [cityToCityToDistance valueForKeyPath:pathString];
            pathDistance += [distance intValue];
        }
        
        if (shortestDistance > pathDistance)
        {
            shortestDistance = pathDistance;
            shortestPath = path;
        }
        
        
        if (longestDistance < pathDistance)
        {
            longestDistance = pathDistance;
            longestPath = path;
        }
    }
    
    NSLog(@"Part 1: %@ has shortest at %d",shortestPath,shortestDistance);
    NSLog(@"Part 2: %@ has longest at %d",longestPath,longestDistance);
    
}

- (NSMutableArray *)generatePermutations:(NSArray *)array
{
    
    NSMutableArray *permutations = nil;
    
    for (int i = 0; i < [array count]; i++)
    {
        if (permutations == nil)
        {
            permutations = [NSMutableArray array];
            for (NSString *character in array)
            {
                [permutations addObject:[NSArray arrayWithObject:character]];
            }
        }
        else
        {
            NSMutableArray *aCopy = [permutations copy];
            [permutations removeAllObjects];
            
            for (NSString *character in array)
            {
                for (NSArray *oldArray in aCopy)
                {
                    if ([oldArray containsObject:character] == NO)
                    {
                        NSMutableArray *newArray = [NSMutableArray arrayWithArray:oldArray];
                        [newArray addObject:character];
                        [permutations addObject:newArray];
                    }
                }
            }            
        }
    }
    return permutations;
}


