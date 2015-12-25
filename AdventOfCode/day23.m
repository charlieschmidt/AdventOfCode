
- (void)day23:(NSArray *)inputs part:(NSNumber *)part
{
    NSMutableDictionary *registers;
    
    if ([part intValue] == 1)
    {
        registers = [[NSMutableDictionary alloc] initWithDictionary:@{@"a":@0,
                                                                      @"b":@0}];
    }
    else
    {
        registers = [[NSMutableDictionary alloc] initWithDictionary:@{@"a":@1,
                                                                      @"b":@0}];
    }
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    
    for (int i = 0; i < [inputs count] && i >= 0; i++)
    {
        NSString *input = inputs[i];
        NSArray *inputContents = [input componentsSeparatedByString:@" "];
        
        if ([inputContents[0] isEqualToString:@"hlf"])
        {
            unsigned long long  v = [[registers valueForKey:inputContents[1]] unsignedLongLongValue];
            
            v = v / 2;
            
            [registers setObject:[NSNumber numberWithUnsignedLongLong:v] forKey:inputContents[1]];
        }
        else if ([inputContents[0] isEqualToString:@"tpl"])
        {
            unsigned long long  v = [[registers valueForKey:inputContents[1]] unsignedLongLongValue];
            
            v = v * 3;
            
            [registers setObject:[NSNumber numberWithUnsignedLongLong:v] forKey:inputContents[1]];
    
        }
        else if ([inputContents[0] isEqualToString:@"inc"])
        {
            unsigned long long v = [[registers valueForKey:inputContents[1]] unsignedLongLongValue];
            
            v++;
            
            [registers setObject:[NSNumber numberWithUnsignedLongLong:v] forKey:inputContents[1]];
            
        }
        else if ([inputContents[0] isEqualToString:@"jmp"])
        {
            NSString *os = inputContents[1];
            int o = [[f numberFromString:[os substringFromIndex:1]] intValue];
            if ([os characterAtIndex:0] == '-')
            {
                o = o * -1;
            }
            
            i += o-1;
        }
        else if ([inputContents[0] isEqualToString:@"jie"])
        {
            NSString *s = [inputContents[1] substringToIndex:1];
            unsigned long long  v = [[registers valueForKey:s] unsignedLongLongValue];
            
            if (v % 2 == 0)
            {
                NSString *os = inputContents[2];
                int o = [[f numberFromString:[os substringFromIndex:1]] intValue];
                if ([os characterAtIndex:0] == '-')
                {
                    o = o * -1 + 1;
                }
                else
                {
                    o--;
                }
                i += o;
            }
        }
        else if ([inputContents[0] isEqualToString:@"jio"])
        {
            NSString *s = [inputContents[1] substringToIndex:1];
            unsigned long long  v = [[registers valueForKey:s] unsignedLongLongValue];
            
            if (v == 1)
            {
                NSString *os = inputContents[2];
                int o = [[f numberFromString:[os substringFromIndex:1]] intValue];
                if ([os characterAtIndex:0] == '-')
                {
                    o = o * -1 + 1;
                }
                else
                {
                    o--;
                }
                i += o;
            }
        }
    }
    
    
    NSLog(@"Part %@: b: %@\n",part, registers[@"b"]);
}

