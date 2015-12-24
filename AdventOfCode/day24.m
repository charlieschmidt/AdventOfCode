
- (void)day24:(NSArray *)inputs part:(NSNumber *)part
{
    NSMutableArray *packageWeights = [[NSMutableArray alloc] init];
    int totalWeight = 0;
    int numberOfPackingMethodsFound = 0;
    unsigned long minimumCountInGroup = [inputs count];
    unsigned long long minimumQE = ULONG_LONG_MAX;
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    
    for (int i = 0; i < [inputs count]; i++)
    {
        NSNumber *n = [f numberFromString:inputs[i]];
    
        totalWeight += [n intValue];
        [packageWeights addObject:n];
    }
    
    int groupWeight;
    
    if ([part intValue] == 1)
    {
        groupWeight = totalWeight / 3;
    }
    else
    {
        groupWeight = totalWeight / 4;
    }
    
    uint64_t num_combos = 1ull << [packageWeights count];    // 2**count
    for (uint64_t mask = 1; mask < num_combos; mask++)
    {
        NSMutableIndexSet *group1Indexes = [[NSMutableIndexSet alloc] init];
        
        for (uint64_t i = 0; i < 64; i++)
        {
            if (mask & (1ull << i))
            {
                [group1Indexes addIndex:i];
            }
        }
    
        __block int group1Weight = 0;
        __block unsigned long long group1QE = 1;
        unsigned long group1Count = [group1Indexes count];
        [packageWeights enumerateObjectsUsingBlock:^(NSNumber *o, NSUInteger idx, BOOL *stop)
        {
            if ([group1Indexes containsIndex:idx])
            {
                group1QE *= [o intValue];
                group1Weight += [o intValue];
            }
        }];
        
        if (group1Weight != groupWeight)
        {
            continue;
        }
        
        NSLog(@"found group1: %@\n",[packageWeights objectsAtIndexes:group1Indexes]);
        
        
        uint64_t num_combos2 = 1ull << [packageWeights count];    // 2**count
        for (uint64_t mask2 = mask+1; mask2 < num_combos2; mask2++)
        {
            NSMutableIndexSet *group2Indexes = [[NSMutableIndexSet alloc] init];
            BOOL usableIndexSetFor2 = YES;
            
            for (uint64_t i2 = 0; i2 < 64; i2++)
            {
                if (mask2 & (1ull << i2))
                {
                    if ([group1Indexes containsIndex:i2] == YES)
                    {
                        usableIndexSetFor2 = NO;
                        break;
                    }
                    [group2Indexes addIndex:i2];
                }
            }

            if (usableIndexSetFor2 == NO)
            {
                continue;
            }
            
            __block int group2Weight = 0;
            __block unsigned long long group2QE = 1;
            unsigned long group2Count = [group2Indexes count];
            [packageWeights enumerateObjectsUsingBlock:^(NSNumber *o, NSUInteger idx, BOOL *stop)
             {
                 if ([group2Indexes containsIndex:idx])
                 {
                     group2Weight += [o intValue];
                     group2QE *= [o intValue];
                 }
             }];
            
            if (group2Weight != groupWeight)
            {
                continue;
            }
            
            
            NSLog(@"found group2: %@\n",[packageWeights objectsAtIndexes:group2Indexes]);
            
            
            if ([part intValue] == 1)
            {
                __block int group3Weight = 0;
                __block unsigned long long group3QE = 1;
                unsigned long group3Count = [packageWeights count] - group2Count - group1Count;
                [packageWeights enumerateObjectsUsingBlock:^(NSNumber *o, NSUInteger idx, BOOL *stop)
                 {
                     if ([group2Indexes containsIndex:idx] == NO && [group1Indexes containsIndex:idx] == NO)
                     {
                         group3Weight += [o intValue];
                         group3QE *= [o intValue];
                     }
                 }];
                
                if (group3Weight != groupWeight)
                {
                    continue;
                }
                
                numberOfPackingMethodsFound++;
                
                if (group1Count <= minimumCountInGroup)
                {
                    minimumCountInGroup = group1Count;
                    
                    if (group1QE < minimumQE)
                    {
                        minimumQE = group1QE;
                        NSLog(@"found new min QE: %llu at %lu\n",minimumQE,minimumCountInGroup);
                    }
                }
                
                if (group2Count <= minimumCountInGroup)
                {
                    minimumCountInGroup = group2Count;
                    
                    if (group2QE < minimumQE)
                    {
                        minimumQE = group2QE;
                        NSLog(@"found new min QE: %llu at %lu\n",minimumQE,minimumCountInGroup);
                    }
                }
                
                if (group3Count <= minimumCountInGroup)
                {
                    minimumCountInGroup = group3Count;
                    
                    if (group3QE < minimumQE)
                    {
                        minimumQE = group3QE;
                        NSLog(@"found new min QE: %llu at %lu\n",minimumQE,minimumCountInGroup);
                    }
                }
            }
            else
            {
                uint64_t num_combos3 = 1ull << [packageWeights count];    // 2**count
                for (uint64_t mask3 = mask2+1; mask3 < num_combos3; mask3++)
                {
                    NSMutableIndexSet *group3Indexes = [[NSMutableIndexSet alloc] init];
                    BOOL usableIndexSetFor3 = YES;
                    
                    for (uint64_t i3 = 0; i3 < 64; i3++)
                    {
                        if (mask3 & (1ull << i3))
                        {
                            if ([group1Indexes containsIndex:i3] == YES || [group2Indexes containsIndex:i3] == YES)
                            {
                                usableIndexSetFor3 = NO;
                                break;
                            }
                            [group3Indexes addIndex:i3];
                        }
                    }
                    
                    if (usableIndexSetFor3 == NO)
                    {
                        continue;
                    }
                    
                    __block int group3Weight = 0;
                    __block unsigned long long group3QE = 1;
                    unsigned long group3Count = [group3Indexes count];
                    [packageWeights enumerateObjectsUsingBlock:^(NSNumber *o, NSUInteger idx, BOOL *stop)
                     {
                         if ([group3Indexes containsIndex:idx])
                         {
                             group3Weight += [o intValue];
                             group3QE *= [o intValue];
                         }
                     }];
                    
                    if (group3Weight != groupWeight)
                    {
                        continue;
                    }
                    
                    
                    NSLog(@"found group3: %@\n",[packageWeights objectsAtIndexes:group3Indexes]);
                    
                    __block int group4Weight = 0;
                    __block unsigned long long group4QE = 1;
                    unsigned long group4Count = [packageWeights count] - group3Count - group2Count - group1Count;
                    [packageWeights enumerateObjectsUsingBlock:^(NSNumber *o, NSUInteger idx, BOOL *stop)
                     {
                         if ([group3Indexes containsIndex:idx] == NO && [group2Indexes containsIndex:idx] == NO && [group1Indexes containsIndex:idx] == NO)
                         {
                             group4Weight += [o intValue];
                             group4QE *= [o intValue];
                         }
                     }];
                    
                    if (group4Weight != groupWeight)
                    {
                        continue;
                    }
                    
                    numberOfPackingMethodsFound++;
                    
                    if (group1Count <= minimumCountInGroup)
                    {
                        minimumCountInGroup = group1Count;
                        
                        if (group1QE < minimumQE)
                        {
                            minimumQE = group1QE;
                            NSLog(@"found new min QE: %llu at %lu\n",minimumQE,minimumCountInGroup);
                        }
                    }
                    
                    if (group2Count <= minimumCountInGroup)
                    {
                        minimumCountInGroup = group2Count;
                        
                        if (group2QE < minimumQE)
                        {
                            minimumQE = group2QE;
                            NSLog(@"found new min QE: %llu at %lu\n",minimumQE,minimumCountInGroup);
                        }
                    }
                    
                    if (group3Count <= minimumCountInGroup)
                    {
                        minimumCountInGroup = group3Count;
                        
                        if (group3QE < minimumQE)
                        {
                            minimumQE = group3QE;
                            NSLog(@"found new min QE: %llu at %lu\n",minimumQE,minimumCountInGroup);
                        }
                    }
                    
                    if (group4Count <= minimumCountInGroup)
                    {
                        minimumCountInGroup = group4Count;
                        
                        if (group4QE < minimumQE)
                        {
                            minimumQE = group3QE;
                            NSLog(@"found new min QE: %llu at %lu\n",minimumQE,minimumCountInGroup);
                        }
                    }
                }

            }
        }
    }
    
    NSLog(@"minimumQE: %llu\n",minimumQE);
}

