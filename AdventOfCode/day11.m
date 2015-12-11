
- (void)day11:(NSArray *)inputs
{
    for (NSString *input in inputs)
    {
        BOOL isValid = NO;
        NSString *nextPassword = input;
        
        NSError *error = NULL;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(\\w)\\1" options:NSRegularExpressionCaseInsensitive error:&error];
        
        do
        {
            nextPassword = [self nextPassword:nextPassword];
        
            
            if ([nextPassword containsString:@"i"] || [nextPassword containsString:@"o"] || [nextPassword containsString:@"l"])
            {
                continue;
            }
            
            BOOL hasTriplet = NO;
            for (int i = 0; i < [nextPassword length] -2; i++)
            {
                if ([nextPassword characterAtIndex:i] == [nextPassword characterAtIndex:i+1]-1 &&
                    [nextPassword characterAtIndex:i] == [nextPassword characterAtIndex:i+2]-2)
                {
                    hasTriplet = YES;
                    break;
                }
            }
            
            NSArray* matches = [regex matchesInString:nextPassword options:0 range:NSMakeRange(0, [nextPassword length])];
            
            if ([matches count] < 2)
            {
                continue;
            }
            
            if (hasTriplet == YES)
            {
                isValid = hasTriplet;
            }
        } while (isValid == NO);
        
        NSLog(@"Current: %@, Next: %@\n",input,nextPassword);
    }
}

-(NSString*)nextPassword:(NSString *)password
{
    NSMutableString *ms = [NSMutableString stringWithString:password];
    for (int i = [ms length] - 1; i >= 0; i--)
    {
        if ([ms characterAtIndex:i] == 'z')
        {
            [ms replaceCharactersInRange:NSMakeRange(i,1) withString:@"a"];
            continue;
        }
        else
        {
            [ms replaceCharactersInRange:NSMakeRange(i,1) withString:[NSString stringWithFormat:@"%c",[ms characterAtIndex:i]+1]];
            break;
        }
    }
    return ms;
}


