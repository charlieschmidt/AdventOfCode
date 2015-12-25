

- (void)day24:(NSArray *)inputs part:(NSNumber *)part
{
    NSMutableArray *packageWeights = [[NSMutableArray alloc] init];
    int totalWeight = 0;
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    
    for (NSString *input in [[inputs reverseObjectEnumerator] allObjects])
    {
        NSNumber *n = [f numberFromString:input];
    
        totalWeight += [n intValue];
        [packageWeights addObject:n];
    }
    
    
    unsigned long numberOfPackages = [packageWeights count];
    
    int targetGroupWeight;
    int maxPackagesPerGroup = 0;
    
    if ([part intValue] == 1)
    {
        targetGroupWeight = totalWeight / 3;
        maxPackagesPerGroup = numberOfPackages / 3.0; // the most packages the min group could have is a # packages / # of divisions; if it was more than that - then all the min groups would have to have more and we'd have more packages than # packages
    }
    else
    {
        targetGroupWeight = totalWeight / 4;
        maxPackagesPerGroup = numberOfPackages / 4.0;
    }
    
    // find the minimum packages the min group could have.  add the input numbers in descending order - once we're over the target weight, we know that is the _fewest_ packages the group could have, cause its using the biggest input numbers
    int j = 0;
    int minPackagesPerGroup = 0;
    for (int i = 0; i < numberOfPackages; i++)
    {
        j += [packageWeights[i] intValue];
        minPackagesPerGroup++;
        if (j > targetGroupWeight)
        {
            break;
        }
    }
    
    // first thing we're going to do is find all the initial groups that equal the target weight, and store them plus their QE in a hash table
    NSMutableDictionary *workingGroup1s = [[NSMutableDictionary alloc] init];
    unsigned long long num_combos = 1ull << numberOfPackages;
    for (int group1Indexes = 1; group1Indexes < num_combos; group1Indexes++)
    {
        unsigned long group1Count = 0;
        
        for (int idx = 0; idx < numberOfPackages; idx++)
        {
            if (bit_is_on(group1Indexes,idx))
            {
                group1Count++;
            }
        }
        
        // if the number in our guess isnt between the available ranges, then give up
        if (group1Count > maxPackagesPerGroup || group1Count < minPackagesPerGroup)
        {
            continue;
        }
        
        // calc weight and QE
        int group1Weight = 0;
        unsigned long long group1QE = 1;
        for (int idx = 0; idx < numberOfPackages; idx++)
        {
             if (bit_is_on(group1Indexes,idx))
             {
                 int i = [packageWeights[idx] intValue];
                 group1QE *= i;
                 group1Weight += i;
             }
        }
        
        if (group1Weight != targetGroupWeight)
        {
            continue;
        }
        
        // if the weight is good, then save the weight and QE for the second round
        [workingGroup1s setObject:[NSNumber numberWithInt:group1Indexes] forKey:[NSNumber numberWithUnsignedLongLong:group1QE]];
        
    }
    
    NSLog(@"Found %lu workable group 1s, sorting and checking those now.\n",[workingGroup1s count]);
    
    // now iterate the hashtable, sorted by key asc
    NSArray *sortedGroup1QEs = [[workingGroup1s allKeys] sortedArrayUsingComparator:^(id obj1, id obj2) {
        if (obj1 > obj2)
            return NSOrderedDescending;
        else if (obj1 < obj2)
            return NSOrderedAscending;
        
        return NSOrderedSame;
    }];
    
    // iterate it, once we find a second group that has the appropriate weight, we know the 3rd group does and whatever the QE is at that point is the winner (cause QE sorts ascending)
    BOOL found = NO;
    for (int i = 0; i < [sortedGroup1QEs count] && found == NO; i++)
    {
        NSNumber *g1qe = sortedGroup1QEs[i];
        unsigned long long group1QE = [g1qe unsignedLongLongValue];
        int group1Indexes = [[workingGroup1s objectForKey:g1qe] intValue];
        
        
        //group1QE = 11846773891;
        //group1Indexes = 268435543;
        
        for (int group2Indexes = 1; group2Indexes < num_combos && found == NO; group2Indexes++)
        {
            if (group2Indexes % 1000000 == 0)
            {
                NSLog(@"\tat %f\n",((double)(group2Indexes)) / ((double)num_combos));
            }
            
            BOOL usableGroup2Indexes = YES;
            int group2Weight = 0;
            for (int idx = 0; idx < numberOfPackages; idx++)
            {
                if (bit_is_on(group2Indexes,idx) == YES )
                {
                    if (bit_is_on(group1Indexes,idx) == YES)
                    {
                        usableGroup2Indexes = NO;
                        break;
                    }
                    int v = [packageWeights[idx] intValue];
                    group2Weight += v;
                }
            }
            
            
            if (usableGroup2Indexes == NO || group2Weight != targetGroupWeight)
            {
                continue;
            }
            
            
            if ([part intValue] == 1)
            {
                NSLog(@"Part %@, minimumQE: %llu\n",part,group1QE);
                found = YES;
            }
            else
            {
                for (int group3Indexes = 1; group3Indexes < num_combos && found == NO; group3Indexes++)
                {
                    if (group3Indexes % 1000000 == 0)
                    {
                        NSLog(@"\tat %f\n",((double)(group3Indexes)) / ((double)num_combos));
                    }
                    
                    BOOL usableGroup3Indexes = YES;
                    int group3Weight = 0;
                    for (int idx = 0; idx < numberOfPackages; idx++)
                    {
                        if (bit_is_on(group3Indexes,idx) == YES )
                        {
                            if (bit_is_on(group1Indexes,idx) == YES || bit_is_on(group2Indexes,idx) == YES)
                            {
                                usableGroup3Indexes = NO;
                                break;
                            }
                            int v = [packageWeights[idx] intValue];
                            group3Weight += v;
                        }
                    }
                    
                    
                    if (usableGroup3Indexes == NO || group3Weight != targetGroupWeight)
                    {
                        continue;
                    }
                    
                    NSLog(@"Part %@, minimumQE: %llu\n",part,group1QE);
                    found = YES;
                }
            }
        }
    }
}

