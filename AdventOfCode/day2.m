
- (void)day2:(NSArray *)inputs
{
    NSInteger totalSquareFeetNeeded = 0;
    NSInteger totalRibbonNeeded = 0;
    
    for (NSString *input in inputs)
    {
        int l,w,h;
        NSInteger squareFeetNeeded = 0;
        NSInteger ribbonNeeded = 0;
        
        sscanf([input UTF8String],"%dx%dx%d",&l,&w,&h);
        
        int side1 = l*w;
        int side2 = l*h;
        int side3 = h*w;
        
        squareFeetNeeded = side1*2 + side2*2 + side3*2 + min(side1,min(side2,side3));
        
        int bow = l*w*h;
        int side1p = l*2 + w*2;
        int side2p = l*2 + h*2;
        int side3p = h*2 + w*2;
        
        ribbonNeeded = bow + min(side1p,min(side2p,side3p));
                
        totalSquareFeetNeeded += squareFeetNeeded;
        totalRibbonNeeded += ribbonNeeded;
    }
    
    NSLog(@"Part 1: Total square feet needed: %ld\n",totalSquareFeetNeeded);
    NSLog(@"Part 2: Total ribbon needed: %ld\n",totalRibbonNeeded);
}
