
- (void)day3:(NSArray *)inputs part:(NSNumber *)part
{
    int numSantas = part.intValue;
    
    for (NSString *input in inputs)
    {
        int x[numSantas];
        int y[numSantas];
        
        for (int i = 0; i < numSantas; i++)
        {
            x[i] = y[i] = 0;
        }
        
        NSInteger len = input.length;
        NSInteger position = 1;
        NSMutableDictionary *houses = [[NSMutableDictionary alloc] init];
        houses[@"0x0"] = @"1";
        
        while (position <= len)
        {
            char c = [input characterAtIndex:position - 1];
       
            int whichSanta = (position - 1) % numSantas;
            
            switch (c)
            {
                case '>': x[whichSanta]++; break;
                case '<': x[whichSanta]--; break;
                case '^': y[whichSanta]++; break;
                case 'v': y[whichSanta]--; break;
                default: break;
            }
        
            NSString *houseKey = [NSString stringWithFormat:@"%dx%d",x[whichSanta],y[whichSanta]];
            
            houses[houseKey] = @"1";
            
            position++;
        }
        
        NSLog(@"Part %d: Unique houses visited by %d santas: %lu\n",numSantas,numSantas,houses.count);
    }

}
