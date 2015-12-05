
- (void)day5:(NSArray *)inputs part:(NSNumber *)part;

{
    NSInteger totalNice = 0;
    NSInteger totalNaughty = 0;
    
    NSError *error = nil;

    if ([part intValue] == 1)
    {
            NSRegularExpression *vowelsRegex = [NSRegularExpression regularExpressionWithPattern:@"[aeiou]" options:0 error:&error];
        NSRegularExpression *badStringsRegex = [NSRegularExpression regularExpressionWithPattern:@"ab|cd|pq|xy" options:0 error:&error];
        NSRegularExpression *doubleLettersRegex = [NSRegularExpression regularExpressionWithPattern:@"([a-z])\\1" options:0 error:&error];
       
        for (NSString *input in inputs)
        {
            //printf("Input: %s\n",[input UTF8String]);
            
            
            NSUInteger vowelCount = [vowelsRegex numberOfMatchesInString:input options:0 range:NSMakeRange(0,[input length])];
            BOOL hasDoubleLetters = ([doubleLettersRegex numberOfMatchesInString:input options:0 range:NSMakeRange(0,[input length])] == 0 ? NO : YES);
            BOOL hasBadStrings = ([badStringsRegex numberOfMatchesInString:input options:0 range:NSMakeRange(0,[input length])] == 0 ? NO : YES);
            
            if (vowelCount >= 3 && hasDoubleLetters == YES && hasBadStrings == NO)
            {
                totalNice++;
            //    printf("Nice\n");
            }
            else
            {
                totalNaughty++;
            //    printf("Naughty\n");
            }
        }
    }
    else
    {
        NSRegularExpression *twoPairsRegex = [NSRegularExpression regularExpressionWithPattern:@"([a-z][a-z])[a-z]*\\1" options:0 error:&error];
        NSRegularExpression *xyxRegex = [NSRegularExpression regularExpressionWithPattern:@"([a-z])[a-z]\\1" options:0 error:&error];
        
        for (NSString *input in inputs)
        {
            //printf("Input: %s\n",[input UTF8String]);
            

        
            BOOL hasTwoPairs = ([twoPairsRegex numberOfMatchesInString:input options:0 range:NSMakeRange(0,[input length])] == 0 ? NO : YES);
            BOOL hasOneSeparatedByAnother = ([xyxRegex numberOfMatchesInString:input options:0 range:NSMakeRange(0,[input length])] == 0 ? NO : YES);
            
            if (hasOneSeparatedByAnother == YES && hasTwoPairs == YES)
            {
                totalNice++;
            //    printf("Nice\n");
            }
            else
            {
                totalNaughty++;
            //    printf("Naughty\n");
            }
        }
    }
    
    printf("Part %d:\n",[part intValue]);
    printf("Total Nice: %ld\n",(long)totalNice);
    printf("Total Naughty: %ld\n",(long)totalNaughty);
}
