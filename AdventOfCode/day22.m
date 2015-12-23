
- (void)day22:(NSArray *)inputs part:(NSNumber *)part
{
    int mana = 500;
    int hp = 50;
    NSDictionary *spells = @{@"magic missile":@{
                                     @"cost":@53,
                                     @"damage":@4},
                             @"drain":@{
                                     @"cost":@73,
                                     @"damage":@2,
                                     @"hpGain":@2},
                             @"shield":@{
                                     @"cost":@113,
                                     @"armor":@7,
                                     @"turns":@6},
                             @"poison":@{
                                     @"cost":@173,
                                     @"damagePerTurn":@3,
                                     @"turns":@6},
                             @"recharge":@{
                                     @"cost":@229,
                                     @"manaGainPerTurn":@101,
                                     @"turns":@5}
      };
    
    int bossHp = 0;
    int bossDamage = 0;
    
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
    }
    
    int bestManaSpent = 5000000;
    
    NSMutableArray *spellList = nil;
    
    if (NO)
    {
        //bossHp = 14;
        //bossDamage = 8;
        //mana = 250;
        //hp = 10;
    
        spellList = [[NSMutableArray alloc] initWithArray:@[@"poison",@"recharge",@"shield",@"poison",@"recharge",@"shield",@"poison",@"recharge",@"shield",@"magic missile",@"poison",@"magic missile"]];
    }
    
    for (NSString *spell in [spells allKeys])
    {
        NSString *spellToPerform = spell;
        
        if (spellList != nil)
        {
            if ([spellList count] != 0)
            {
                spellToPerform = spellList[0];
                [spellList removeObjectAtIndex:0];
            }
            else
            {
                spellToPerform = nil;
            }
        }
        
        NSMutableArray *spellsPerformed = [[NSMutableArray alloc] init];
    
        [self doRPGTurn:spells
         spellToPerform:spellToPerform
            hpRemaining:hp
          manaRemaining:mana
                  armor:0
        bossHpRemaining:bossHp
             bossDamage:bossDamage
    currentStatusEffects:nil
         totalManaSpent:0
          bestManaSpent:&bestManaSpent
              spellList:spellList
        spellsPerformed:spellsPerformed
               hardMode:([part intValue] ==2)
         ];
    }
    
    NSLog(@"Part %@: minimum mana spend & win: %d\n",part,bestManaSpent);
}



- (void) doRPGTurn:(NSDictionary*)spells
          spellToPerform:(NSString *)spellToPerform
             hpRemaining:(int)hpRemaining
           manaRemaining:(int)manaRemaining
                   armor:(int)armor
         bossHpRemaining:(int)bossHpRemaining
              bossDamage:(int)bossDamage
    currentStatusEffects:(NSMutableArray*)currentStatusEffects
          totalManaSpent:(int)totalManaSpent
           bestManaSpent:(int*)bestManaSpent
               spellList:(NSMutableArray *)spellList
         spellsPerformed:(NSArray *)spellsPerformed
                hardMode:(BOOL)hardMode
{
    NSMutableString *effects = [[NSMutableString alloc] initWithString:@"("];
    for (NSDictionary *effect in currentStatusEffects)
    {
        [effects appendFormat:@"%@ (%@ left),",effect[@"name"],effect[@"turnsRemaining"]];
    }
    [effects appendString:@")"];
    
    NSString *spellDescription = [[NSString alloc] initWithFormat:@"%@ (%d,%d,%d) vs (%d) with %@",spellToPerform,hpRemaining,manaRemaining,armor,bossHpRemaining,effects];
    NSMutableArray *newSpellsPerformed = [[NSMutableArray alloc] initWithArray:spellsPerformed];
    [newSpellsPerformed addObject:spellDescription];

    // do player turn
    if (hardMode == YES)
    {
        hpRemaining--;
        
        if (hpRemaining <= 0)
        {
            return;
        }
    }
    
    //NSLog(@"\n\n");
    //NSLog(@"Player turn p(%d,%d,%d) vs b(%d)\n",hpRemaining,manaRemaining,armor,bossHpRemaining);
    // check status effects
    currentStatusEffects = [self doStatusEffects:currentStatusEffects spells:spells hpRemaining:&hpRemaining manaRemaining:&manaRemaining armor:&armor bossHpRemaining:&bossHpRemaining];
    
    // check if boss is dead
    //NSLog(@"After status effects, p(%d,%d,%d) vs b(%d)\n",hpRemaining,manaRemaining,armor,bossHpRemaining);
    if (bossHpRemaining <= 0)
    {
        if (totalManaSpent < *bestManaSpent)
        {
            //NSLog(@"%@ led to boss death at cost of %d (vs %d) (%d,%d,%d)\n",newSpellsPerformed,totalManaSpent,*bestManaSpent,hpRemaining,manaRemaining,armor);
            *bestManaSpent = totalManaSpent;
        }
        return;
    }
    
    // cast spell
    if (spellToPerform == nil)
    {
        return;
    }
    
    manaRemaining -= [spells[spellToPerform][@"cost"] intValue];
    totalManaSpent += [spells[spellToPerform][@"cost"] intValue];
    armor += [spells[spellToPerform][@"armor"] intValue];
    hpRemaining += [spells[spellToPerform][@"hpGain"] intValue];
    bossHpRemaining -= [spells[spellToPerform][@"damage"] intValue];
    //NSLog(@"cast %@ for %d mana (%d left): %d armor, %d hp, %d damage\n",spellToPerform,[spells[spellToPerform][@"cost"] intValue],manaRemaining,[spells[spellToPerform][@"armor"] intValue],[spells[spellToPerform][@"hpGain"] intValue],[spells[spellToPerform][@"damage"] intValue]);
    int turns = [spells[spellToPerform][@"turns"] intValue];
    if (turns != 0)
    {
        NSMutableDictionary *statusEffect = [[NSMutableDictionary alloc] init];
        statusEffect[@"name"] = spellToPerform;
        statusEffect[@"turnsRemaining"] = [NSNumber numberWithInt:turns];
        statusEffect[@"manaGainPerTurn"] = spells[spellToPerform][@"manaGainPerTurn"];
        statusEffect[@"damagePerTurn"] = spells[spellToPerform][@"damagePerTurn"];
        
        [currentStatusEffects addObject:statusEffect];
    }
    
    // check if boss is dead
    if (bossHpRemaining <= 0)
    {
        if (totalManaSpent < *bestManaSpent)
        {
            //NSLog(@"%@ led to boss death at cost of %d (vs %d) (%d,%d,%d)\n",newSpellsPerformed,totalManaSpent,*bestManaSpent,hpRemaining,manaRemaining,armor);
            *bestManaSpent = totalManaSpent;
        }
        return;
    }
    //NSLog(@"end player turn p(%d,%d,%d) vs b(%d)\n",hpRemaining,manaRemaining,armor,bossHpRemaining);
    // end player turn
    
    
    
    // do boss turn
    //NSLog(@"Boss turn p(%d,%d,%d) vs b(%d)\n",hpRemaining,manaRemaining,armor,bossHpRemaining);
    
    // check status effects
    currentStatusEffects = [self doStatusEffects:currentStatusEffects spells:spells hpRemaining:&hpRemaining manaRemaining:&manaRemaining armor:&armor bossHpRemaining:&bossHpRemaining];
    
    // check if boss is dead
    //NSLog(@"After status effects, p(%d,%d,%d) vs b(%d)\n",hpRemaining,manaRemaining,armor,bossHpRemaining);
    if (bossHpRemaining <= 0)
    {
        if (totalManaSpent < *bestManaSpent)
        {
            //NSLog(@"%@ led to boss death at cost of %d (vs %d) (%d,%d,%d)\n",newSpellsPerformed,totalManaSpent,*bestManaSpent,hpRemaining,manaRemaining,armor);
            *bestManaSpent = totalManaSpent;
        }
        return;
    }
    
    // boss attack
    hpRemaining -= max(1,bossDamage - armor);
    //NSLog(@"boss does %d damage, player now at %d\n",max(1,bossDamage-armor),hpRemaining);
    
    // check if player is dead
    if (hpRemaining <= 0)
    {
        //NSLog(@"%@ led to player death\n",spellsPerformed);
        return;
    }
    // end boss turn
    
    
    // exit early, cant do better than this
    if (totalManaSpent >= *bestManaSpent)
    {
        return;
    }
    
    // try to exit early, hopefully
    if ([spellsPerformed count] >= 15)
    {
        return;
    }
    
    // do next turn
    for (NSString *spell in [spells allKeys])
    {
        NSString *nextSpellToPerform = spell;

        if (spellList != nil)
        {
            if ([spellList count] != 0)
            {
                nextSpellToPerform = spellList[0];
                [spellList removeObjectAtIndex:0];
            }
            else
            {
                nextSpellToPerform = nil;
            }
        }
        
        BOOL cantPerform = NO;
        for (NSDictionary *effect in currentStatusEffects)
        {
            if ([effect[@"name"] isEqualToString:nextSpellToPerform] && [effect[@"turnsRemaining"] intValue] > 1)
            {
                cantPerform = YES;
            }
        }
        
        if (cantPerform == NO && manaRemaining >= [spells[nextSpellToPerform][@"cost"] intValue])
        {
            [self doRPGTurn:spells
             spellToPerform:nextSpellToPerform
                hpRemaining:hpRemaining
              manaRemaining:manaRemaining
                      armor:armor
            bossHpRemaining:bossHpRemaining
                 bossDamage:bossDamage
       currentStatusEffects:currentStatusEffects
             totalManaSpent:totalManaSpent
              bestManaSpent:bestManaSpent
                  spellList:spellList
            spellsPerformed:newSpellsPerformed
                   hardMode:hardMode
              ];
        }
    
    };
    
    return;
}


- (NSMutableArray *)doStatusEffects:(NSArray*)currentStatusEffects
spells:(NSDictionary*)spells
hpRemaining:(int*)hpRemaining
manaRemaining:(int*)manaRemaining
armor:(int*)armor
bossHpRemaining:(int*)bossHpRemaining
{
    NSMutableArray *statusEffects;
    if (currentStatusEffects == nil)
    {
        return [[NSMutableArray alloc] init];
    }
    else
    {
        
        statusEffects = [[NSMutableArray alloc] init];
        for (NSMutableDictionary *effect in currentStatusEffects)
        {
            NSMutableDictionary *effectCopy = [[NSMutableDictionary alloc] initWithDictionary:effect copyItems:YES];
            [statusEffects addObject:effectCopy];
        }
    }
    
    NSMutableArray *statusEffectsToRemove = [NSMutableArray array];
    for (NSMutableDictionary *statusEffect in statusEffects)
    {
        int turnsRemaining = [statusEffect[@"turnsRemaining"] intValue];
        
        if (turnsRemaining >= 1)
        {
            if ([statusEffect[@"name"] isEqualToString:@"poison"])
            {
                *bossHpRemaining -= [spells[@"poison"][@"damagePerTurn"] intValue];
                
                //NSLog(@"boss takes poison damage for %d, left at %d (%d remaining)\n",[spells[@"poison"][@"damagePerTurn"] intValue],*bossHpRemaining,turnsRemaining-1);
                
            }
            else if ([statusEffect[@"name"] isEqualToString:@"shield"])
            {
                //NSLog(@"shield still active (%d remaining)\n",turnsRemaining-1);
            }
            else if ([statusEffect[@"name"] isEqualToString:@"recharge"])
            {
                *manaRemaining += [spells[@"recharge"][@"manaGainPerTurn"] intValue];
                //NSLog(@"you recharge %d mana, now at %d (%d remaining)\n",[spells[@"recharge"][@"manaGainPerTurn"] intValue],*manaRemaining,turnsRemaining-1);
            }
            
            turnsRemaining--;
            statusEffect[@"turnsRemaining"] = [NSNumber numberWithInt:turnsRemaining];
            
        }
        else
        {
            if ([statusEffect[@"name"] isEqualToString:@"shield"])
            {
                //NSLog(@"shield wears off\n");
                *armor -= [spells[@"shield"][@"armor"] intValue];
            }
            
            [statusEffectsToRemove addObject:statusEffect];
        }
    }
    
    [statusEffects removeObjectsInArray:statusEffectsToRemove];
    
    return statusEffects;
}
