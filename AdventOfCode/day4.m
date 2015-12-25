
- (void)day4:(NSArray *)inputs part:(NSNumber *)part
{
    printf("Part: %d\n",[part intValue]);
    NSString *comparator;
    if ([part intValue] == 1)
    {
        comparator = @"00000";
    }
    else
    {
        comparator = @"000000";
    }
    
    for (NSString *input in inputs)
    {
        printf("Input: %s\n",[input UTF8String]);
        
        int i = 0;
        BOOL found = NO;
        
        while (!found)
        {
            NSString *secretKey = [NSString stringWithFormat:@"%@%d",input,i];
            NSString *md5 = [self md5For:secretKey];
            if ([[md5 substringToIndex:[comparator length]] compare:comparator] == NSOrderedSame)
            {
                found = YES;
                break;
            }
            i++;
        }
        
        
        printf("Key: %d\n",i);
    }
    
    printf("\n");
}

- (NSString *)md5For:(NSString *)string
{
    const char *ptr = [string UTF8String];

    // Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    unsigned long l = strlen(ptr);
    if (l > UINT_MAX)
    {
        NSLog(@"fuck if i know how we're handling this now :)\n");
        return nil;
    }
    
    CC_LONG len = 0;
    len = (unsigned int)l;
    // Create 16 byte MD5 hash value, store in buffer
    CC_MD5(ptr, len, md5Buffer);
    
    // Convert MD5 value in the buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x",md5Buffer[i]];
    
    return output;
}