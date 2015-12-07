
typedef enum {
    And,
    Or,
    LShift,
    RShift,
    Compliment,
    Set
} Operation;

- (void)day7:(NSArray *)inputs part:(NSNumber *)part;
{
    NSMutableDictionary *wires = [[NSMutableDictionary alloc] init];
    NSMutableArray *mInputs = [NSMutableArray arrayWithArray:inputs];
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    
    BOOL firstTime = YES;
    int inputCounter = 0;
    while ([mInputs count])
    {
        if (inputCounter >= [mInputs count])
        {
            inputCounter = 0;
        }
        
        NSString *input = [mInputs objectAtIndex:inputCounter];
        BOOL wasAbleToProcess = NO;
        
        
        Operation op;
        
        if ([input containsString:@"AND"])
        {
            op = And;
        }
        else if ([input containsString:@"OR"])
        {
            op = Or;
        }
        else if ([input containsString:@"LSHIFT"])
        {
            op = LShift;
        }
        else if ([input containsString:@"RSHIFT"])
        {
            op = RShift;
        }
        else if ([input containsString:@"NOT"])
        {
            op = Compliment;
        }
        else
        {
            op = Set;
        }
        
        switch (op)
        {
            case And:
            {
                char lhs[10];
                char rhs[10];
                char dest[10];
                sscanf([input UTF8String],"%s AND %s -> %s",lhs,rhs,dest);
                NSString *lhss = [NSString stringWithCString:lhs encoding:NSUTF8StringEncoding];
                NSString *rhss = [NSString stringWithCString:rhs encoding:NSUTF8StringEncoding];
                
                NSNumber *lhsv = [nf numberFromString:lhss];
                if (lhsv == nil)
                {
                    lhsv = [wires valueForKey:lhss];
                }
                
                NSNumber *rhsv = [nf numberFromString:rhss];
                if (rhsv == nil)
                {
                    rhsv = [wires valueForKey:rhss];
                }
                
                if (lhsv != nil & rhsv != nil)
                {
                    wasAbleToProcess = YES;
                    uint16_t v = [lhsv unsignedIntValue] & [rhsv unsignedIntValue];
                    NSNumber *destv = [NSNumber numberWithUnsignedInt:v];
                    [wires setValue:destv forKey:[NSString stringWithCString:dest encoding:NSUTF8StringEncoding]];
                }
                break;
            }
            case Or:
            {
                char lhs[10];
                char rhs[10];
                char dest[10];
                sscanf([input UTF8String],"%s OR %s -> %s",lhs,rhs,dest);
                NSString *lhss = [NSString stringWithCString:lhs encoding:NSUTF8StringEncoding];
                NSString *rhss = [NSString stringWithCString:rhs encoding:NSUTF8StringEncoding];
                
                NSNumber *lhsv = [nf numberFromString:lhss];
                if (lhsv == nil)
                {
                    lhsv = [wires valueForKey:lhss];
                }
                
                NSNumber *rhsv = [nf numberFromString:rhss];
                if (rhsv == nil)
                {
                    rhsv = [wires valueForKey:rhss];
                }
                
                if (lhsv != nil & rhsv != nil)
                {
                    wasAbleToProcess = YES;
                    uint16_t v = [lhsv unsignedIntValue] | [rhsv unsignedIntValue];
                    NSNumber *destv = [NSNumber numberWithUnsignedInt:v];
                    [wires setValue:destv forKey:[NSString stringWithCString:dest encoding:NSUTF8StringEncoding]];
                }
                
                break;
            }
            case LShift:
            {
                char lhs[10];
                uint16_t by;
                char dest[10];
                sscanf([input UTF8String],"%s LSHIFT %hu -> %s",lhs,&by,dest);
                
                NSNumber *lhsv = [wires valueForKey:[NSString stringWithCString:lhs encoding:NSUTF8StringEncoding]];
                
                if (lhsv != nil)
                {
                    wasAbleToProcess = YES;
                    uint16_t v = [lhsv unsignedIntValue] << by;
                    NSNumber *destv = [NSNumber numberWithUnsignedInt:v];
                    [wires setValue:destv forKey:[NSString stringWithCString:dest encoding:NSUTF8StringEncoding]];
                }
                
                break;
            }
            case RShift:
            {
                char lhs[10];
                uint16_t by;
                char dest[10];
                sscanf([input UTF8String],"%s RSHIFT %hu -> %s",lhs,&by,dest);
                
                NSNumber *lhsv = [wires valueForKey:[NSString stringWithCString:lhs encoding:NSUTF8StringEncoding]];
                
                if (lhsv != nil)
                {
                    wasAbleToProcess = YES;
                    uint16_t v = [lhsv unsignedIntValue] >> by;
                    NSNumber *destv = [NSNumber numberWithUnsignedInt:v];
                    [wires setValue:destv forKey:[NSString stringWithCString:dest encoding:NSUTF8StringEncoding]];
                }
                
                break;
            }
            case Compliment:
            {
                char lhs[10];
                char dest[10];
                sscanf([input UTF8String],"NOT %s -> %s",lhs,dest);
                
                NSNumber *lhsv = [wires valueForKey:[NSString stringWithCString:lhs encoding:NSUTF8StringEncoding]];
                
                if (lhsv != nil)
                {
                    wasAbleToProcess = YES;
                    uint16_t v = (~[lhsv unsignedIntValue]);
                    NSNumber *destv = [NSNumber numberWithUnsignedInt:v];
                    [wires setValue:destv forKey:[NSString stringWithCString:dest encoding:NSUTF8StringEncoding]];
                }
                
                break;
            }
            case Set:
            {
                char v[10];
//                uint16_t v;
                char dest[10];
                sscanf([input UTF8String],"%s -> %s",v,dest);
                
                BOOL isNumeric = YES;
                for (int i = 0; v[i] != '\0'; i++)
                {
                    if (!isdigit(v[i]))
                    {
                        isNumeric = NO;
                        break;
                    }
                }
                
                NSNumber *destv = nil;
                if (isNumeric)
                {
                    uint16_t vi = atoi(v);
                    destv = [NSNumber numberWithUnsignedInt:vi];
                }
                else
                {
                    destv = [wires valueForKey:[NSString stringWithCString:v encoding:NSUTF8StringEncoding]];
                }
                
                if (destv != nil)
                {
                    NSString *dests = [NSString stringWithCString:dest encoding:NSUTF8StringEncoding];
                    if ([wires valueForKey:dests] == nil)
                    {
                        [wires setValue:destv forKey:dests];
                    }
                    
                    wasAbleToProcess = YES;
                }
                
                break;
            }
            default:
                break;
        }
        
        if (wasAbleToProcess)
        {
            [mInputs removeObjectAtIndex:inputCounter];
        }
        else
        {
            inputCounter++;
        }
        
        
        if ([part intValue] == 2 && [mInputs count] == 0 && firstTime == YES)
        {
            firstTime = NO;
            NSNumber *av = [wires valueForKey:@"a"];
            [wires removeAllObjects];
            [wires setValue:av forKey:@"b"];
            inputCounter = 0;
            mInputs = [NSMutableArray arrayWithArray:inputs];
        }
       
    }
    
    printf("Part %d\n",[part intValue]);
    for( NSString *wireName in wires )
    {
        if ([wireName compare:@"a"] == NSOrderedSame)
        {
            NSNumber *v = [wires valueForKey:wireName];
            printf("%s: %hu\n",[wireName UTF8String], [v unsignedIntValue]);
        }
    }
   
}
