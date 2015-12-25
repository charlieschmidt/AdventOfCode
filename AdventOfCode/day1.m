
- (void)day1:(NSArray*)inputs
{
    for (NSString *input in inputs)
    {   
        NSInteger len = [input length];
        NSInteger floor = 0;
        NSInteger position = 1;
        NSInteger firstPositionToBasement = -1;
        
        while (position <= len)
        {
            char c = [input characterAtIndex:position - 1];
            
            if (c == ')')
            {
                floor--;
            }
            else if (c == '(')
            {
                floor++;
            }
            
            if (floor == -1 && firstPositionToBasement == -1)
            {
                firstPositionToBasement = position;
            }
            
            position++;
        }
        
        NSLog(@"Part 1: Final floor: %ld\n",floor);
        NSLog(@"Part 2: Enters basement: %ld\n",firstPositionToBasement);
    }
}