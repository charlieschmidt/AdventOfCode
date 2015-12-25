
- (void)day18:(NSArray *)inputs part:(NSNumber *)part
{
    int dimensions = 100;
    char lights[dimensions][dimensions];
    
    for (int i = 0; i < dimensions; i++)
    {
        NSString *input = inputs[i];
        
        for (int j = 0; j < dimensions; j++)
        {
            char state = [input characterAtIndex:j];
            lights[i][j] = state;
        }
    }
    
    if ([part intValue] == 2)
    {
        lights[0][0] = lights[dimensions-1][0] = lights[0][dimensions-1] = lights[dimensions-1][dimensions-1] = '#';
    }
    
    int steps = 100;
    
    for (int s = 0; s < steps; s++)
    {
        
        char lightsCopy[dimensions][dimensions];
     
        for (int i = 0; i < dimensions; i++)
        {
            for (int j = 0; j < dimensions; j++)
            {
                lightsCopy[i][j] = lights[i][j];
            }
        }
        
        for (int i = 0; i < dimensions; i++)
        {
            for (int j = 0; j < dimensions; j++)
            {
                char state = lightsCopy[i][j];
                
                int neighborsOn = 0;
                if (i > 0)
                {
                    if (j > 0)
                    {
                        neighborsOn += (lightsCopy[i-1][j-1] == '#' ? 1 : 0);
                    }
                    if (j < dimensions-1)
                    {
                        neighborsOn += (lightsCopy[i-1][j+1] == '#' ? 1 : 0);
                    }
                    neighborsOn += (lightsCopy[i-1][j] == '#' ? 1 : 0);
                }
                
                if (i < dimensions-1)
                {
                    
                    if (j > 0)
                    {
                        neighborsOn += (lightsCopy[i+1][j-1] == '#' ? 1 : 0);
                    }
                    if (j < dimensions-1)
                    {
                        neighborsOn += (lightsCopy[i+1][j+1] == '#' ? 1 : 0);
                    }
                    neighborsOn += (lightsCopy[i+1][j] == '#' ? 1 : 0);
                }
                {
                    if (j > 0)
                    {
                        neighborsOn += (lightsCopy[i][j-1] == '#' ? 1 : 0);
                    }
                    if (j < dimensions-1)
                    {
                        neighborsOn += (lightsCopy[i][j+1] == '#' ? 1 : 0);
                    }
                }

                if (state == '#')
                {
                    if (neighborsOn != 2 && neighborsOn != 3)
                    {
                        lights[i][j] = '.';
                    }
                }
                else
                {
                    if (neighborsOn == 3)
                    {
                        lights[i][j] = '#';
                    }
                }
                
                if ([part intValue] == 2)
                {
                    lights[0][0] = lights[dimensions-1][0] = lights[0][dimensions-1] = lights[dimensions-1][dimensions-1] = '#';
                }
            }
        }
    }
    
    int countOn = 0;
    for (int i = 0; i < dimensions; i++)
    {
        for (int j = 0; j < dimensions; j++)
        {
            if (lights[i][j] == '#')
            {
                countOn++;
            }
        }
    }
    
    NSLog(@"Part %@: Lights On: %d\n",part,countOn);
}
