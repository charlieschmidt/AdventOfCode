
- (void)day1:(NSArray*)inputs
{
    for (NSString *input in inputs)
    {
        NSLog(@"Input: %@\n",input);
        
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
        
        NSLog(@"Final floor: %ld, enters basement at %ld\n",floor, firstPositionToBasement);
    }
}