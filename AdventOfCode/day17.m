
- (void)day17:(NSArray *)inputs
{
    int volumeGoal = 150;
    NSMutableArray *containers = [[NSMutableArray alloc] init];
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    
    for (NSString *input in inputs)
    {
        NSNumber *number = [f numberFromString:input];
        [containers addObject:number];
    
    }
    
    
    uint64_t num_combos = 1ull << [containers count];    // 2**count
    NSMutableArray *combos = [NSMutableArray new];
    for (uint64_t mask = 1; mask < num_combos; mask++) {
        NSMutableIndexSet *indexes = [NSMutableIndexSet indexSet];
        
        for (uint64_t i = 0; i < 64; i++) {
            if (mask & (1ull << i) ){
                [indexes addIndex:i];
            }
        }
        [combos addObject:[containers objectsAtIndexes:indexes]];
    }
    
    int containersThatWork = 0;
    unsigned long minimumCount = [containers count];
    
    for (int i = 0; i < [combos count]; i++)
    {
        NSArray *subContainers = [combos objectAtIndex:i];
        int volume = 0;
        
        for (int j = 0; j < [subContainers count]; j++)
        {
            NSNumber *number = [subContainers objectAtIndex:j];
            
            volume += [number intValue];
        }
        
        if (volume == volumeGoal)
        {
            containersThatWork++;
            
            if ([subContainers count] < minimumCount)
            {
                minimumCount = [subContainers count];
            }
        }
        
    }
    
    int combosWithMinimumCount = 0;
    
    for (int i = 0; i < [combos count]; i++)
    {
        NSArray *subContainers = [combos objectAtIndex:i];
        int volume = 0;
        
        for (int j = 0; j < [subContainers count]; j++)
        {
            NSNumber *number = [subContainers objectAtIndex:j];
            
            volume += [number intValue];
        }
        
        if (volume == volumeGoal && [subContainers count] == minimumCount)
        {
            combosWithMinimumCount++;
        }
    }
    
    
    NSLog(@"%d\n",containersThatWork);
    
    NSLog(@"%d with minimum count %lu\n",combosWithMinimumCount, minimumCount);
}
