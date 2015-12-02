
- (void)day1:(NSArray*)inputs
{
    for (NSString *input in inputs)
    {
        printf("Input: %s\n",[input UTF8String]);
        
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
        
        printf("Final floor: %ld, enters basement at %ld\n",(long)floor, (long)firstPositionToBasement);
    }
}