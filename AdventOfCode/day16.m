
- (void)day16:(NSArray *)inputs part:(NSNumber *)part
{
    NSDictionary *giftInformation = @{
                                      @"children": @3,
                                      @"cats": @7,
                                      @"samoyeds": @2,
                                      @"pomeranians": @3,
                                      @"akitas": @0,
                                      @"vizslas": @0,
                                      @"goldfish": @5,
                                      @"trees": @3,
                                      @"cars": @2,
                                      @"perfumes": @1
                                      };
    NSMutableArray *sueInformations = [[NSMutableArray alloc] init];
    NSError *error = nil;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"Sue (\\d*): (\\w*): (\\d*), (\\w*): (\\d*), (\\w*): (\\d*)" options:0 error:&error];
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    
    for (NSString *input in inputs)
    {
        NSArray *matches = [regex matchesInString:input options:0 range:NSMakeRange(0,[input length])];
        for (NSTextCheckingResult *result in matches)
        {
            NSNumber *sueNumber = [f numberFromString:[input substringWithRange:[result rangeAtIndex:1]]];
            NSString *thing1 = [input substringWithRange:[result rangeAtIndex:2]];
            NSNumber *countOfThing1 = [f numberFromString:[input substringWithRange:[result rangeAtIndex:3]]];
            NSString *thing2 = [input substringWithRange:[result rangeAtIndex:4]];
            NSNumber *countOfThing2 = [f numberFromString:[input substringWithRange:[result rangeAtIndex:5]]];
            NSString *thing3 = [input substringWithRange:[result rangeAtIndex:6]];
            NSNumber *countOfThing3 = [f numberFromString:[input substringWithRange:[result rangeAtIndex:7]]];
            
            NSMutableDictionary *information = [[NSMutableDictionary alloc] init];
            [information setObject:sueNumber forKey:@"sueNumber"];
            [information setObject:countOfThing1 forKey:thing1];
            [information setObject:countOfThing2 forKey:thing2];
            [information setObject:countOfThing3 forKey:thing3];
            [sueInformations addObject:information];
            
        }
    }
    
    BOOL fuzzy = ([part intValue] == 2);
    
    for (int i = 0; i < [sueInformations count]; i++)
    {
        BOOL isThisOne = YES;
        NSMutableDictionary *information = [sueInformations objectAtIndex:i];
    
        for (NSString *key in [information allKeys])
        {
            if ([key isEqualToString:@"sueNumber"])
            {
                continue;
            }
            NSNumber *informationValue = [information objectForKey:key];
            NSNumber *giftValue = [giftInformation objectForKey:key];
            BOOL b = [self compareInformation:key giftValue:giftValue sueValue:informationValue fuzzy:fuzzy];

            if (b == NO)
            {
                isThisOne = NO;
                break;
            }
        }
        
        if (isThisOne)
        {
            NSLog(@"Part %@: Sue: %@\n",part, [information objectForKey:@"sueNumber"]);
            break;
        }
    }
}

- (BOOL) compareInformation:(NSString *)key giftValue:(NSNumber *)giftValue sueValue:(NSNumber *)sueValue fuzzy:(BOOL)fuzzy
{
    if (fuzzy == NO)
    {
        return [giftValue isEqualToNumber:sueValue];
    }
    else
    {
        if ([key isEqualToString:@"cats"] || [key isEqualToString:@"trees"])
        {
            return ([giftValue intValue] < [sueValue intValue]);
        }
        
        if ([key isEqualToString:@"pomeranians"] || [key isEqualToString:@"goldfish"])
        {
            return ([giftValue intValue] > [sueValue intValue]);
        }
        
        return [giftValue isEqualToNumber:sueValue];
    }
}
