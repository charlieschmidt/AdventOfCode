
#define TOGGLE 1
#define TURNON 2
#define TURNOFF 3

- (void)day6:(NSArray *)inputs part:(NSNumber *)part;

{
    int lights[1000][1000] = {0};
    
    for (NSString *input in inputs)
    {
        int command;
        
        int x1,y1,x2,y2;
        
        if ([input compare:@"toggle" options:0 range:NSMakeRange(0,6)] == NSOrderedSame)
        {
            command = TOGGLE;
            sscanf([input UTF8String],"toggle %d,%d through %d,%d",&x1,&y1,&x2,&y2);
        }
        else if ([input compare:@"turn on" options:0 range:NSMakeRange(0,7)] == NSOrderedSame)
        {
            command = TURNON;
            sscanf([input UTF8String],"turn on %d,%d through %d,%d",&x1,&y1,&x2,&y2);
        }
        else
        {
            command = TURNOFF;
            sscanf([input UTF8String],"turn off %d,%d through %d,%d",&x1,&y1,&x2,&y2);
        }
        
        for (int i = x1; i <= x2; i++)
        {
            for (int j = y1; j <= y2; j++)
            {
                if ([part intValue] == 1)
                {
                    switch (command)
                    {
                        case TOGGLE:
                            lights[i][j] = (lights[i][j]+1)%2;
                            break;
                        case TURNON:
                            lights[i][j] = 1;
                            break;
                        case TURNOFF:
                            lights[i][j] = 0;
                            break;
                        default:
                            break;
                    }
                }
                else
                {
                    switch (command)
                    {
                        case TOGGLE:
                            lights[i][j] += 2;
                            break;
                        case TURNON:
                            lights[i][j] += 1;
                            break;
                        case TURNOFF:
                            lights[i][j] -= 1;
                            if (lights[i][j] <= 0)
                            {
                                lights[i][j] = 0;
                            }
                            break;
                        default:
                            break;
                    }
                }
            }
        }
    }
    
    printf("Part %d:\n",[part intValue]);
    int totalOn = 0;
    for (int i = 0; i < 1000; i++)
    {
        for (int j = 0; j < 1000; j++)
        {
            totalOn += lights[i][j];
        }
    }
    printf("Total On/Brightness: %d\n",totalOn);
}
