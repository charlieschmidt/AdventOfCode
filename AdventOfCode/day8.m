
- (void)day8:(NSArray *)inputs
{
    int totalCharacters = 0;
    int totalStringLength = 0;
    int totalNewStringLength = 0;
    
    for (NSString *input in inputs)
    {
        totalCharacters += input.length;
        
        NSString *insideInput = [input substringWithRange:NSMakeRange(1,input.length-2)];
        NSString *newString = @"\"\\\"";
        
        int i = 0;
        unsigned long left = insideInput.length;
        while (left > 0)
        {
            NSString *chars = [insideInput substringWithRange:NSMakeRange(i,min(left,2))];

            if ([chars compare:@"\\\\"] == NSOrderedSame)
            {
                totalStringLength += 1;
                i += 2;
                left -= 2;
                newString = [newString stringByAppendingString:@"\\\\\\\\"];
            }
            else if ([chars compare:@"\\\""] == NSOrderedSame)
            {
                totalStringLength += 1;
                i += 2;
                left -= 2;
                newString = [newString stringByAppendingString:@"\\\\\\\""];
            }
            else if ([chars compare:@"\\x"] == NSOrderedSame)
            {
                newString = [newString stringByAppendingString:@"\\"];
                newString = [newString stringByAppendingString:[insideInput substringWithRange:NSMakeRange(i,4)]];
                
                totalStringLength += 1;
                i += 4;
                left -= 4;
            }
            else
            {
                totalStringLength += 1;
                i += 1;
                left -= 1;
                newString = [newString stringByAppendingString:[chars substringToIndex:1]];
            }
            
            
        }
        
        newString = [newString stringByAppendingString:@"\\\"\""];
        totalNewStringLength += newString.length;
        
    }
    
    NSLog(@"Part 1: %d - %d = %d\n",totalCharacters, totalStringLength, totalCharacters - totalStringLength);
    NSLog(@"Part 2: %d - %d = %d\n",totalNewStringLength, totalCharacters, totalNewStringLength - totalCharacters);
    
}
