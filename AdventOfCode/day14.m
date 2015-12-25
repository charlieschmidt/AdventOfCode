
- (void)day14:(NSArray *)inputs
{
    NSMutableDictionary *reindeerStats = [[NSMutableDictionary alloc] init];
    NSError *error = nil;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(\\w*) can fly (\\d*) km/s for (\\d*) seconds, but then must rest for (\\d*) seconds." options:0 error:&error];
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    
    for (NSString *input in inputs)
    {
        NSArray *matches = [regex matchesInString:input options:0 range:NSMakeRange(0,input.length)];
        for (NSTextCheckingResult *result in matches)
        {
            NSString *reindeerName = [input substringWithRange:[result rangeAtIndex:1]];
            NSNumber *speed = [f numberFromString:[input substringWithRange:[result rangeAtIndex:2]]];
            NSNumber *flyingPeriod = [f numberFromString:[input substringWithRange:[result rangeAtIndex:3]]];
            NSNumber *restPeriod = [f numberFromString:[input substringWithRange:[result rangeAtIndex:4]]];
            
            NSMutableDictionary *reindeer = [[NSMutableDictionary alloc] init];
            reindeer[@"speed"] = speed;
            reindeer[@"flyingPeriod"] = flyingPeriod;
            reindeer[@"restPeriod"] = restPeriod;
            
            reindeer[@"points"] = @0;
            
            reindeerStats[reindeerName] = reindeer;
            
        }
    }
    
    int maxSeconds = 2503;
    
    for (int i = 0; i <= maxSeconds; i++)
    {
        for (NSString *reindeerName in reindeerStats.allKeys)
        {
            NSMutableDictionary *reindeer = reindeerStats[reindeerName];
            
            NSNumber *speed = reindeer[@"speed"];
            NSNumber *flyingPeriod = reindeer[@"flyingPeriod"];
            NSNumber *restPeriod = reindeer[@"restPeriod"];
            int distanceFlown = [reindeer[@"distanceFlown"] intValue];
        
            int relativeSeconds = i % (restPeriod.intValue + flyingPeriod.intValue);
            
            if (relativeSeconds < flyingPeriod.intValue)
            {
                distanceFlown += speed.intValue;
            }
            
            reindeer[@"distanceFlown"] = @(distanceFlown);
        }
        
        int furthestDistance = 0;
        
        for (NSString *reindeerName in reindeerStats.allKeys)
        {
            NSMutableDictionary *reindeer = reindeerStats[reindeerName];
            
            int distanceFlown = [reindeer[@"distanceFlown"] intValue];
        
            if (distanceFlown >= furthestDistance)
            {
                furthestDistance = distanceFlown;
            }
        }
        
        
        for (NSString *reindeerName in reindeerStats.allKeys)
        {
            NSMutableDictionary *reindeer = reindeerStats[reindeerName];
            
            int distanceFlown = [reindeer[@"distanceFlown"] intValue];
            
            if (distanceFlown == furthestDistance)
            {
                int points = [reindeer[@"points"] intValue];
                points++;
                reindeer[@"points"] = @(points);
            }
        }
    }
    
    NSNumber *maxDistanceFlown = @0;
    NSNumber *maxPoints = @0;
    for (NSString *reindeerName in reindeerStats.allKeys)
    {
        NSMutableDictionary *reindeer = reindeerStats[reindeerName];
        NSNumber *distanceFlown = reindeer[@"distanceFlown"];
        
        NSNumber *points = reindeer[@"points"];
        
        if (distanceFlown > maxDistanceFlown)
        {
            maxDistanceFlown = distanceFlown;
        }
        
        if (points > maxPoints)
        {
            maxPoints = points;
        }
    }
    
    NSLog(@"Part 1: Winning Distance: %@\n",maxDistanceFlown);
    NSLog(@"Part 2: Winning Points: %@\n",maxPoints);
}

