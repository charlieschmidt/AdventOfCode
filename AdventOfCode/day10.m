
- (void)day10:(NSArray *)inputs
{
    NSString *input = inputs[0];
    unsigned long part1Answer = 0;
    unsigned long part2Answer = 0;
    
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
        
        if (iter == 40)
        {
            part1Answer = [new length];
        }
        part2Answer = [new length];
    }
    
    NSLog(@"Part 1: After 40 Iterations: %lu\n",part1Answer);
    NSLog(@"Part 2: After 50 Iterations: %lu\n",part2Answer);
}


