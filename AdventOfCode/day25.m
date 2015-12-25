
- (void)day25:(NSArray *)inputs
{
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"To continue, please consult the code grid in the manual.  Enter the code at row (\\d*), column (\\d*)." options:0 error:&error];

    int targetRow = 0;
    int targetColumn = 0;
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    
    NSArray *matches = [regex matchesInString:inputs[0] options:0 range:NSMakeRange(0,[inputs[0] length])];
    for (NSTextCheckingResult *result in matches)
    {
        targetRow = [[f numberFromString:[inputs[0] substringWithRange:[result rangeAtIndex:1]]] intValue];
        targetColumn = [[f numberFromString:[inputs[0] substringWithRange:[result rangeAtIndex:2]]] intValue];
    }
    
    
    int columnsInFirstRow = targetColumn + targetRow - 1;
    
    long long code = 20151125;
    BOOL found = NO;
    
    for (int i = 2; i <= columnsInFirstRow && found == NO; i++)
    {
        int r = i;
        int c = 1;
        
        while (c <= i && found == NO)
        {
            code = (code * 252533) % 33554393;
            if (r == targetRow && c == targetColumn)
            {
                NSLog(@"Code: %lld\n",code);
                found = YES;
            }
            r--;
            c++;
        }
    }
}
