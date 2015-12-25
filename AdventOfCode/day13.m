
- (void)day13:(NSArray *)inputs part:(NSNumber*)part
{
    NSMutableDictionary *personToPersonHappiness = [[NSMutableDictionary alloc] init];
    NSError *error = nil;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(\\w*) would (\\w*) (\\d*) happiness units by sitting next to (\\w*)." options:0 error:&error];
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    
    for (NSString *input in inputs)
    {
        NSArray *matches = [regex matchesInString:input options:0 range:NSMakeRange(0,[input length])];
        for (NSTextCheckingResult *result in matches)
        {
            NSString *sourcePerson = [input substringWithRange:[result rangeAtIndex:1]];
            NSString *gainLoseString = [input substringWithRange:[result rangeAtIndex:2]];
            NSNumber *units = [f numberFromString:[input substringWithRange:[result rangeAtIndex:3]]];
            NSString *destPerson = [input substringWithRange:[result rangeAtIndex:4]];
            
            if ([gainLoseString isEqualToString:@"lose"] == YES)
            {
                units = [NSNumber numberWithInt:[units intValue] * -1];
            }
            
            NSMutableDictionary *sourcePersonDict = [personToPersonHappiness valueForKey:sourcePerson];
            if (sourcePersonDict == nil)
            {
                sourcePersonDict = [[NSMutableDictionary alloc] init];
                [personToPersonHappiness setObject:sourcePersonDict forKey:sourcePerson];
            }
            
            [sourcePersonDict setObject:units forKey:destPerson];
            
        }
    }
    if ([part intValue] == 2)
    {
        NSMutableDictionary *youPersonDict = [[NSMutableDictionary alloc] init];
        for (NSString *person in [personToPersonHappiness allKeys])
        {
            NSMutableDictionary *personDict = [personToPersonHappiness valueForKey:person];
            [personDict setObject:[NSNumber numberWithInt:0] forKey:@"you"];
            [youPersonDict setObject:[NSNumber numberWithInt:0] forKey:person];
        }
        [personToPersonHappiness setObject:youPersonDict forKey:@"you"];
    }
    
    NSMutableArray *paths = [self generatePermutations:[personToPersonHappiness allKeys]];
    
    int largestHappiness = 0;
    NSArray *largestPath;
    for (NSArray *path in paths)
    {
        int pathHappiness = 0;
        for (int i = 0; i < [path count]-1; i++)
        {
            NSString *sourcePerson = path[i];
            NSString *destPerson = path[i+1];
            NSString *pathString = [NSString stringWithFormat:@"%@.%@",sourcePerson,destPerson];
            NSNumber *happiness = [personToPersonHappiness valueForKeyPath:pathString];
            pathHappiness += [happiness intValue];
            
            pathString = [NSString stringWithFormat:@"%@.%@",destPerson,sourcePerson];
            happiness = [personToPersonHappiness valueForKeyPath:pathString];
            pathHappiness += [happiness intValue];
        }
        
        
        NSString *sourcePerson = path[0];
        NSString *destPerson = path[[path count]-1];
        NSString *pathString = [NSString stringWithFormat:@"%@.%@",sourcePerson,destPerson];
        NSNumber *happiness = [personToPersonHappiness valueForKeyPath:pathString];
        pathHappiness += [happiness intValue];
        
        pathString = [NSString stringWithFormat:@"%@.%@",destPerson,sourcePerson];
        happiness = [personToPersonHappiness valueForKeyPath:pathString];
        pathHappiness += [happiness intValue];
        
        if (largestHappiness < pathHappiness)
        {
            largestHappiness = pathHappiness;
            largestPath = path;
        }
    }
    
    NSLog(@"Part %@: %@ has largest at %d",part, largestPath,largestHappiness);
    
}

