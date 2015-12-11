
- (void)day10:(NSArray *)inputs
{
    NSString *input = inputs[0];

    NSLog(@"Input: '%@'\n",input);
    
    for (int iter = 1; iter <= 50; iter++)
    {
        NSMutableString *new = [NSMutableString stringWithString:@""];
        char currentDigit = [input characterAtIndex:0];
        int countOfCurrent = 0;
        
        for (int i = 0; i < [input length]; i++)
        {
            char nextDigit = [input characterAtIndex:i];
            
            if (currentDigit == nextDigit)
            {
                countOfCurrent++;
            }
            else
            {
                [new appendFormat:@"%d%c",countOfCurrent,currentDigit];
                countOfCurrent = 1;
                currentDigit = nextDigit;
            }
            
        }
        
        [new appendFormat:@"%d%c",countOfCurrent,currentDigit];
        input = new;
        
        NSLog(@"Length after %d iterations, %lu\n",iter, (unsigned long)[new length]);
    }
}


