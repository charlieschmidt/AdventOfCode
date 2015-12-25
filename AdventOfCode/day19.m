
- (void)day19:(NSArray *)inputs part:(NSNumber *)part
{
    NSMutableArray *replacementKeys = [[NSMutableArray alloc] init];
    NSMutableArray *replacementValues = [[NSMutableArray alloc] init];
    NSString *inputMolecule;
    NSError *error = nil;

    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(\\w*) => (\\w*)" options:0 error:&error];
    
    for (NSString *input in inputs)
    {
        inputMolecule = input;
        
        NSArray *matches = [regex matchesInString:input options:0 range:NSMakeRange(0,input.length)];
        for (NSTextCheckingResult *result in matches)
        {
            NSString *key = [input substringWithRange:[result rangeAtIndex:1]];
            NSString *value = [input substringWithRange:[result rangeAtIndex:2]];
            
            [replacementKeys addObject:key];
            [replacementValues addObject:value];
        }
    }
    
    if (part.intValue == 1)
    {
        NSMutableDictionary *newMolecules = [[NSMutableDictionary alloc] init];
        
        for (int i = 0; i < replacementKeys.count; i++)
        {
            NSString *key = replacementKeys[i];
            NSString *value = replacementValues[i];
            
            NSRange searchRange = NSMakeRange(0,inputMolecule.length);
            NSRange foundRange;
            //NSLog(@"%@ -> %@\n",key,value);
            while (searchRange.location < inputMolecule.length)
            {
                searchRange.length = inputMolecule.length - searchRange.location;
                foundRange = [inputMolecule rangeOfString:key options:0 range:searchRange];
                
                if (foundRange.location != NSNotFound)
                {
                    //NSLog(@"\tfound occurance of %@ in %@ at %dx%d\n",key, inputMolecule,foundRange.location,foundRange.length);
                    
                    NSMutableString *newMolecule = [[NSMutableString alloc] initWithString:inputMolecule];
                    [newMolecule replaceCharactersInRange:foundRange withString:value];

                    //NSLog(@"\tnew molecule: %@\n",newMolecule);
                    newMolecules[newMolecule] = newMolecule;
                    searchRange.location = foundRange.location + foundRange.length;
                }
                else
                {
                    // no more substring to find
                    break;
                }
            }
        };

        NSLog(@"Part 1: New Molecules: %lu\n", (unsigned long)newMolecules.count);
    }
    else
    {
        int numElements = 0;
        int numRnAr = 0;
        int numY = 0;
        
        for (int i = 0; i < inputMolecule.length; i++)
        {
            char atIndex = [inputMolecule characterAtIndex:i];
            char nextIndex = ' ';
            if (i < inputMolecule.length - 1)
            {
                nextIndex = [inputMolecule characterAtIndex:i+1];
            }
            
            if ((atIndex == 'R' && nextIndex == 'n') || (atIndex == 'A' && nextIndex == 'r'))
            {
                numRnAr++;
            }
            else if (atIndex == 'Y')
            {
                numY++;
            }
            
            if (isupper(atIndex))
            {
                numElements++;
            }
        }
        
        int s = numElements - numRnAr - (2 * numY) - 1;
        NSLog(@"Part 2: %d - %d - 2 * %d - 1 = %d",numElements, numRnAr, numY,s);
        
        
        /*
        
        NSMutableString *newMolecule = [[NSMutableString alloc] initWithString:inputMolecule];
        int steps = 0;
        
        while ([newMolecule isEqualToString:@"e"] == NO)
        {
            NSString *bestKey;
            NSRange bestReplacementRange = NSMakeRange(0,0);
            
            for (int i = 0; i < [replacementKeys count]; i++)
            {
                NSString *key = replacementKeys[i];
                NSString *value = replacementValues[i];
         
                NSRange searchRange = NSMakeRange(0,newMolecule.length);
                NSRange foundRange;
                while (searchRange.location < newMolecule.length)
                {
                    searchRange.length = newMolecule.length - searchRange.location;
                    foundRange = [newMolecule rangeOfString:value options:0 range:searchRange];
                    
                    if (foundRange.location != NSNotFound)
                    {
                        if (foundRange.length > bestReplacementRange.length)
                        {
                            bestReplacementRange = foundRange;
                            bestKey = key;
                        }
                        
                        searchRange.location = foundRange.location + foundRange.length;
                    }
                    else
                    {
                        // no more substring to find
                        break;
                    }
                }
            }
            
            // i got lucky with my input, but others ive seen fell into this and needed to add a shuffle to the replacements and pick one, instead of pick longest. lame for them.
            if (bestReplacementRange.length == 0)
            {
                NSLog(@"Stuck at %d with %@\n",steps,newMolecule);
                break;
            }
            
            [newMolecule replaceCharactersInRange:bestReplacementRange withString:bestKey];
            
            steps++;
        }
         NSLog(@"Part 2: Steps to 'e': %d\n",steps);
         */
    }
    
}
