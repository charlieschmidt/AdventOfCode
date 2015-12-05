
- (void)day5:(NSArray *)inputs
{
    NSInteger totalNice = 0;
    NSInteger totalNaughty = 0;
    
    int problemNum = 2;
    
    for (NSString *input in inputs)
    {
        printf("Input: %s\n",[input UTF8String]);
        
        if (problemNum == 1)
        {
            NSInteger vowelCount = 0;
            char prevLetter = '\0';
            BOOL hasDoubleLetters = NO;
            BOOL hasBadStrings = NO;
            
            for (int i = 0; i < [input length]; i++)
            {
                char c = [input characterAtIndex:i];
                if (c == 'a' || c == 'e' || c == 'i' || c == 'o' || c == 'u')
                {
                    vowelCount++;
                }
                
                if (c == prevLetter)
                {
                    hasDoubleLetters = YES;
                }
                prevLetter = c;
            }
            
            if ([input containsString:@"ab"] ||
                [input containsString:@"cd"] ||
                [input containsString:@"pq"] ||
                [input containsString:@"xy"])
            {
                hasBadStrings = YES;
            }
            
            if (vowelCount >= 3 && hasDoubleLetters == YES && hasBadStrings == NO)
            {
                totalNice++;
                printf("Nice\n");
            }
            else
            {
                totalNaughty++;
                printf("Naughty\n");
            }
        }
        else
        {
            BOOL hasTwoPairs = NO;
            BOOL hasOneSeparatedByAnother = NO;
            
            for (int i = 0; i < [input length] - 2; i++)
            {
                NSString *pair = [input substringWithRange:NSMakeRange(i,2)];
                
                NSRange range = [input rangeOfString:pair options:NSLiteralSearch range:NSMakeRange(i+2,[input length] - (i+2))];
                
                if (range.location != NSNotFound)
                {
                    hasTwoPairs = YES;
                }
                
                if ([input characterAtIndex:i] == [input characterAtIndex:i+2])
                {
                    hasOneSeparatedByAnother = YES;
                }
                
            }
            
            if (hasOneSeparatedByAnother == YES && hasTwoPairs == YES)
            {
                totalNice++;
                printf("Nice\n");
            }
            else
            {
                totalNaughty++;
                printf("Naughty\n");
            }
        }
    }
    
    printf("\n");
    printf("Total Nice: %ld\n",(long)totalNice);
    printf("Total Naughty: %ld\n",(long)totalNaughty);
}
