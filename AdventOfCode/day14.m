
- (void)day14:(NSArray *)inputs
{
    NSMutableDictionary *reindeerStats = [[NSMutableDictionary alloc] init];
    NSError *error = nil;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(\\w*) can fly (\\d*) km/s for (\\d*) seconds, but then must rest for (\\d*) seconds." options:0 error:&error];
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    
    for (NSString *input in inputs)
    {
        NSArray *matches = [regex matchesInString:input options:0 range:NSMakeRange(0,[input length])];
        for (NSTextCheckingResult *result in matches)
        {
            NSString *reindeerName = [input substringWithRange:[result rangeAtIndex:1]];
            NSNumber *speed = [f numberFromString:[input substringWithRange:[result rangeAtIndex:2]]];
            NSNumber *flyingPeriod = [f numberFromString:[input substringWithRange:[result rangeAtIndex:3]]];
            NSNumber *restPeriod = [f numberFromString:[input substringWithRange:[result rangeAtIndex:4]]];
            
            NSMutableDictionary *reindeer = [[NSMutableDictionary alloc] init];
            [reindeer setObject:speed forKey:@"speed"];
            [reindeer setObject:flyingPeriod forKey:@"flyingPeriod"];
            [reindeer setObject:restPeriod forKey:@"restPeriod"];
            
            [reindeer setObject:[NSNumber numberWithInt:0] forKey:@"points"];
            
            [reindeerStats setObject:reindeer forKey:reindeerName];
            
        }
    }
    
    int maxSeconds = 2503;
    
    for (int i = 0; i <= maxSeconds; i++)
    {
        for (NSString *reindeerName in [reindeerStats allKeys])
        {
            NSMutableDictionary *reindeer = [reindeerStats objectForKey:reindeerName];
            
            NSNumber *speed = [reindeer objectForKey:@"speed"];
            NSNumber *flyingPeriod = [reindeer objectForKey:@"flyingPeriod"];
            NSNumber *restPeriod = [reindeer objectForKey:@"restPeriod"];
            int distanceFlown = [[reindeer objectForKey:@"distanceFlown"] intValue];
        
            int relativeSeconds = i % ([restPeriod intValue] + [flyingPeriod intValue]);
            
            if (relativeSeconds < [flyingPeriod intValue])
            {
                distanceFlown += [speed intValue];
            }
            
            [reindeer setObject:[NSNumber numberWithInt:distanceFlown] forKey:@"distanceFlown"];
        }
        
        int furthestDistance = 0;
        
        for (NSString *reindeerName in [reindeerStats allKeys])
        {
            NSMutableDictionary *reindeer = [reindeerStats objectForKey:reindeerName];
            
            int distanceFlown = [[reindeer objectForKey:@"distanceFlown"] intValue];
        
            if (distanceFlown >= furthestDistance)
            {
                furthestDistance = distanceFlown;
            }
        }
        
        
        for (NSString *reindeerName in [reindeerStats allKeys])
        {
            NSMutableDictionary *reindeer = [reindeerStats objectForKey:reindeerName];
            
            int distanceFlown = [[reindeer objectForKey:@"distanceFlown"] intValue];
            
            if (distanceFlown == furthestDistance)
            {
                int points = [[reindeer objectForKey:@"points"] intValue];
                points++;
                [reindeer setObject:[NSNumber numberWithInt:points] forKey:@"points"];
            }
        }
    }
    
    for (NSString *reindeerName in [reindeerStats allKeys])
    {
        NSMutableDictionary *reindeer = [reindeerStats objectForKey:reindeerName];
        NSNumber *distanceFlown = [reindeer objectForKey:@"distanceFlown"];
        
        NSNumber *points = [reindeer objectForKey:@"points"];
        NSLog(@"After %d seconds, %@ flew %@ and has %@ points\n",maxSeconds,reindeerName,distanceFlown,points);
    }
    
    
}

