
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
  
    for (NSString *spell in [spells allKeys])
    {
        
        NSMutableArray *spellsPerformed = [[NSMutableArray alloc] init];
    
        [self doRPGTurn:spells
         spellToPerform:spell
            hpRemaining:hp
          manaRemaining:mana
                  armor:0
        bossHpRemaining:bossHp
             bossDamage:bossDamage
    currentStatusEffects:nil
         totalManaSpent:0
          bestManaSpent:&bestManaSpent
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
    
    // check status effects
    currentStatusEffects = [self doStatusEffects:currentStatusEffects spells:spells hpRemaining:&hpRemaining manaRemaining:&manaRemaining armor:&armor bossHpRemaining:&bossHpRemaining];
    
    // check if boss is dead
    if (bossHpRemaining <= 0)
    {
        if (totalManaSpent < *bestManaSpent)
        {
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
            *bestManaSpent = totalManaSpent;
        }
        return;
    }
    // end player turn
    
    
    
    // do boss turn
    // check status effects
    currentStatusEffects = [self doStatusEffects:currentStatusEffects spells:spells hpRemaining:&hpRemaining manaRemaining:&manaRemaining armor:&armor bossHpRemaining:&bossHpRemaining];
    
    // check if boss is dead
    if (bossHpRemaining <= 0)
    {
        if (totalManaSpent < *bestManaSpent)
        {
            *bestManaSpent = totalManaSpent;
        }
        return;
    }
    
    // boss attack
    hpRemaining -= max(1,bossDamage - armor);
    
    // check if player is dead
    if (hpRemaining <= 0)
    {
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
            *bossHpRemaining -= [spells[statusEffect[@"name"]][@"damagePerTurn"] intValue];
            *manaRemaining += [spells[statusEffect[@"name"]][@"manaGainPerTurn"] intValue];
            
            turnsRemaining--;
            statusEffect[@"turnsRemaining"] = [NSNumber numberWithInt:turnsRemaining];
            
        }
        else
        {
            *armor -= [spells[statusEffect[@"name"]][@"armor"] intValue];
            
            [statusEffectsToRemove addObject:statusEffect];
        }
    }
    
    [statusEffects removeObjectsInArray:statusEffectsToRemove];
    
    return statusEffects;
}
