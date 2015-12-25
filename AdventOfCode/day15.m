
- (void)day15:(NSArray *)inputs part:(NSNumber *)part
{
    NSMutableArray *ingredients = [[NSMutableArray alloc] init];
    NSError *error = nil;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(\\w*): capacity ([-\\d]*), durability ([-\\d]*), flavor ([-\\d]*), texture ([-\\d]*), calories ([-\\d]*)" options:0 error:&error];
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    
    for (NSString *input in inputs)
    {
        NSArray *matches = [regex matchesInString:input options:0 range:NSMakeRange(0,[input length])];
        for (NSTextCheckingResult *result in matches)
        {
            NSString *ingredientName = [input substringWithRange:[result rangeAtIndex:1]];
            NSNumber *capacity = [f numberFromString:[input substringWithRange:[result rangeAtIndex:2]]];
            NSNumber *durability = [f numberFromString:[input substringWithRange:[result rangeAtIndex:3]]];
            NSNumber *flavor = [f numberFromString:[input substringWithRange:[result rangeAtIndex:4]]];
            NSNumber *texture = [f numberFromString:[input substringWithRange:[result rangeAtIndex:5]]];
            NSNumber *calories = [f numberFromString:[input substringWithRange:[result rangeAtIndex:6]]];
            
            NSMutableDictionary *ingredient = [[NSMutableDictionary alloc] init];
            [ingredient setObject:ingredientName forKey:@"ingredientName"];
            [ingredient setObject:capacity forKey:@"capacity"];
            [ingredient setObject:durability forKey:@"durability"];
            [ingredient setObject:flavor forKey:@"flavor"];
            [ingredient setObject:texture forKey:@"texture"];
            [ingredient setObject:calories forKey:@"calories"];
            
            [ingredients addObject:ingredient];
            
        }
    }
    
    int ingredientCounts[[ingredients count]];
    int maxScore = 0;
    BOOL calorieConstraint = ([part intValue] == 2);
    
    [self iterateIngredients:ingredients ingredientCounts:ingredientCounts currentIndex:0 maxScore:&maxScore calorieConstraint:calorieConstraint];
    
    NSLog(@"Part %@: Max Score: %d\n",part, maxScore);
}

- (void)iterateIngredients:(NSMutableArray *)ingredients
          ingredientCounts:(int *)ingredientCounts
              currentIndex:(int)currentIndex
                  maxScore:(int*)maxScore
          calorieConstraint:(BOOL)calorieConstraint
{
    int currentTotal = 0;
    for (int i = 0; i < currentIndex; i++)
    {
        currentTotal += ingredientCounts[i];
    }
    
    if (currentIndex == [ingredients count])
    {
        if (currentTotal > 100)
        {
            return;
        }
        int capacity = [self sumIngredientProperty:ingredients ingredientCounts:ingredientCounts property:@"capacity" ];
        int durability = [self sumIngredientProperty:ingredients ingredientCounts:ingredientCounts property:@"durability" ];
        int flavor = [self sumIngredientProperty:ingredients ingredientCounts:ingredientCounts property:@"flavor" ];
        int texture = [self sumIngredientProperty:ingredients ingredientCounts:ingredientCounts property:@"texture" ];
        
        if (calorieConstraint == YES)
        {
            int calories = [self sumIngredientProperty:ingredients ingredientCounts:ingredientCounts property:@"calories" ];

            if (calories != 500)
            {
                return;
            }
        }
        
        int score = capacity * durability * flavor * texture;
        
        if (score > *maxScore)
        {
            *maxScore = score;
        }
        
        return;
    }
    
    if (currentIndex < [ingredients count])
    {
        for (int i = 0; i <= 100 - currentTotal; i++)
        {
            ingredientCounts[currentIndex] = i;
            
            [self iterateIngredients:ingredients ingredientCounts:ingredientCounts currentIndex:currentIndex+1 maxScore:maxScore calorieConstraint:calorieConstraint];
        }
    }
}

- (int) sumIngredientProperty:(NSMutableArray *)ingredients
             ingredientCounts:(int *)ingredientCounts
                     property:(NSString *)property
{
    int s = 0;
    for (int i = 0; i < [ingredients count]; i++)
    {
        NSMutableDictionary *d = [ingredients objectAtIndex:i];
        NSNumber *n = [d objectForKey:property];
        s += [n intValue] * ingredientCounts[i];
    }

    return max(s,0);
}
