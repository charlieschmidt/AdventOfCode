
- (void)day21:(NSArray *)inputs
{
    NSArray *weapons = @[@{@"name":@"dagger",
                           @"cost":@8,
                           @"damage":@4},
                         @{@"name":@"shortsword",
                           @"cost":@10,
                           @"damage":@5},
                         @{@"name":@"warhammer",
                           @"cost":@25,
                           @"damage":@6},
                         @{@"name":@"longsword",
                           @"cost":@40,
                           @"damage":@7},
                         @{@"name":@"greataxe",
                           @"cost":@74,
                           @"damage":@8}
                         ];
    NSArray *armors = @[@{@"name":@"leather",
                          @"cost":@13,
                          @"armor":@1},
                        @{@"name":@"chainmail",
                          @"cost":@31,
                          @"armor":@2},
                        @{@"name":@"splintmail",
                          @"cost":@53,
                          @"armor":@3},
                        @{@"name":@"bandedmail",
                          @"cost":@75,
                          @"armor":@4},
                        @{@"name":@"platemail",
                          @"cost":@102,
                          @"armor":@5},
                          ];
    NSArray *rings = @[@{@"name":@"a+1",
                         @"cost":@20,
                         @"damage":@0,
                         @"armor":@1},
                       @{@"name":@"a+2",
                         @"cost":@40,
                         @"damage":@0,
                         @"armor":@2},
                       @{@"name":@"a+3",
                         @"cost":@80,
                         @"damage":@0,
                         @"armor":@3},
                       @{@"name":@"d+1",
                         @"cost":@25,
                         @"damage":@1,
                         @"armor":@0},
                       @{@"name":@"d+2",
                         @"cost":@50,
                         @"damage":@2,
                         @"armor":@0},
                       @{@"name":@"d+3",
                         @"cost":@100,
                         @"damage":@3,
                         @"armor":@0},
                          ];
    
    uint64_t num_combos = 1ull << [rings count];    // 2**count
    NSMutableArray *ringCombos = [NSMutableArray new];
    for (uint64_t mask = 1; mask < num_combos; mask++) {
        NSMutableIndexSet *indexes = [NSMutableIndexSet indexSet];
        
        for (uint64_t i = 0; i < 64; i++) {
            if (mask & (1ull << i) ){
                [indexes addIndex:i];
            }
        }
        [ringCombos addObject:[rings objectsAtIndexes:indexes]];
    }
    
    
    int bossHp;
    int bossDamage;
    int bossArmor;

    
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    for (NSString *input in inputs)
    {
        NSRange colon = [input rangeOfString:@":"];
        NSString *number = [input substringFromIndex:colon.location+2];
        
        if ([[input substringToIndex:3] isEqualToString:@"Hit"])
        {
            bossHp = [[f numberFromString:number] intValue];
        }
        if ([[input substringToIndex:3] isEqualToString:@"Dam"])
        {
            bossDamage = [[f numberFromString:number] intValue];
        }
        if ([[input substringToIndex:3] isEqualToString:@"Arm"])
        {
            bossArmor = [[f numberFromString:number] intValue];
        }
    }
    
    int minCost = 100000;
    int maxCost = 0;

    for (NSDictionary *weapon in weapons)
    {
        for (NSArray *rings in ringCombos)
        {
            for (NSDictionary *armor in armors)
            {
                int cost = 0;
                
                int pDamage = [[weapon valueForKey:@"damage"] intValue];
                cost += [[weapon valueForKey:@"cost"] intValue];
                
                int pArmor = [[armor valueForKey:@"armor"] intValue];
                cost += [[armor valueForKey:@"cost"] intValue];
                
                for (NSDictionary *ring in rings)
                {
                    pDamage += [[ring valueForKey:@"damage"] intValue];
                    pArmor += [[ring valueForKey:@"armor"] intValue];
                    cost += [[ring valueForKey:@"cost"] intValue];
                }
                
                int pMoves = ceil(((double)bossHp) / ((double)max(pDamage - bossArmor,1)));
                int bossMoves = ceil(100.0 / ((double)max(bossDamage - pArmor,1)));
                
                if (pMoves <= bossMoves)
                {
                    if (cost < minCost)
                    {
                        minCost = cost;
                    }
                }
                else
                {
                    if (cost > maxCost)
                    {
                        maxCost = cost;
                    }
                }
            }
        }
    }
    
    NSLog(@"Part 1: minimum cost & win: %d\n",minCost);
    NSLog(@"Part 2: maximum cost & lose: %d\n",maxCost);
}
