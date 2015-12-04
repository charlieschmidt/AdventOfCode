
- (void)day4:(NSArray *)inputs
{
    for (NSString *input in inputs)
    {
        printf("Input: %s\n",[input UTF8String]);
        
        int i = 0;
        BOOL found = NO;
        
        while (!found)
        {
            NSString *secretKey = [NSString stringWithFormat:@"%@%d",input,i];
            NSString *md5 = [self md5For:secretKey];
            if ([[md5 substringToIndex:6] compare:@"000000"] == NSOrderedSame)
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
    
    // Create 16 byte MD5 hash value, store in buffer
    CC_MD5(ptr, strlen(ptr), md5Buffer);
    
    // Convert MD5 value in the buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x",md5Buffer[i]];
    
    return output;
}