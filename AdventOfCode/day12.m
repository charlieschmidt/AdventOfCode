
- (void)day12:(NSArray *)inputs part:(NSNumber *)part
{
    NSString *input = [inputs componentsJoinedByString:@""];
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding];
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    int sum = [self sumJsonObject:json ignoreRed:([part intValue] == 2)];
    
    NSLog(@"Part %@, sum: %d\n",part,sum);
}




- (int)sumJsonObject:(id)obj ignoreRed:(BOOL)ignoreRed
{
    if ([obj isKindOfClass:[NSNumber class]])
    {
        return [obj intValue];
    }
    else if ([obj isKindOfClass:[NSArray class]])
    {
        __block int sum = 0;
        [obj enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            sum += [self sumJsonObject:obj ignoreRed:ignoreRed];
        }];
        return sum;
    }
    else if ([obj isKindOfClass:[NSDictionary class]])
    {
        __block int sum = 0;
        [obj enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if (ignoreRed == YES &&
                ([obj isKindOfClass:[NSString class]] && [obj isEqualToString:@"red"]))
            {
                sum = 0;
                *stop = YES;
            }
            sum += [self sumJsonObject:obj ignoreRed:ignoreRed];
        }];
        return sum;
    }
    
    return 0;
}