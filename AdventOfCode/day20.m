
- (void)day20:(NSArray *)inputs part:(NSNumber *)part
{
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    
    NSNumber *number = [f numberFromString:inputs[0]];
    int targetValue = [number intValue];
    
    int *housePresents = malloc(sizeof(int)*targetValue);
    memset(housePresents,0,sizeof(int)*targetValue);
    
    for (int elf = 1; elf <= targetValue; elf++)
    {
        
        if ([part intValue] == 1)
        {
            for (int house = elf; house <= targetValue; house += elf)
            {
                housePresents[house-1] += elf * 10;
            }
        }
        else
        {
            for (int house = elf, visits = 0; house <= targetValue && visits < 50; house += elf, visits++)
            {
                housePresents[house-1] += elf * 11;
            }
        }
            
    }
        
    for (int i = 0; i < targetValue; i++)
    {
        if (housePresents[i] >= targetValue)
        {
            NSLog(@"Part %@: House %d has %d\n",part,i+1,housePresents[i]);
            break;
        }
    }
    
    free(housePresents);
}
