
- (void)day3:(NSArray *)inputs
{
    for (NSString *input in inputs)
    {
        printf("Input: %s\n",[input UTF8String]);
     
        int x[2] = {0,0};
        int y[2] = {0,0};
        
        NSInteger len = [input length];
        NSInteger position = 1;
        NSMutableDictionary *houses = [[NSMutableDictionary alloc] init];
        [houses setObject:@"1" forKey:@"0x0"];
        
        while (position <= len)
        {
            char c = [input characterAtIndex:position - 1];
       
            int whichSanta = (position - 1) % 2;
            
            switch (c)
            {
                case '>': x[whichSanta]++; break;
                case '<': x[whichSanta]--; break;
                case '^': y[whichSanta]++; break;
                case 'v': y[whichSanta]--; break;
                default: break;
            }
        
            NSString *houseKey = [NSString stringWithFormat:@"%dx%d",x[whichSanta],y[whichSanta]];
            
            [houses setObject:@"1" forKey:houseKey];
            
            position++;
        }
        
        printf("Unique houses visited: %lu\n",(unsigned long)[houses count]);
    }
    
    printf("\n");
}