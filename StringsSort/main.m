//
//  main.m
//  StringsSort
//
//  Created by Jeff Kelley on 8/17/13.
//  Copyright (c) 2013 Detroit Labs. All rights reserved.
//


#import <Foundation/Foundation.h>


int main(int argc, const char * argv[])
{
    @autoreleasepool {
        
        NSArray *args = [[NSProcessInfo processInfo] arguments];
        
        if ([args count] == 3) {
            NSString *path = args[1];
            
            NSStringEncoding encoding;
            
            NSError *loadError = nil;
            
            NSString *contents =
            [[NSString alloc] initWithContentsOfFile:path
                                        usedEncoding:&encoding
                                               error:&loadError];
            
            if (contents) {
                NSArray *lines =
                [contents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
                
                NSMutableDictionary *stringsByCategory =
                [[NSMutableDictionary alloc] init];
                
                NSString *currentCategory = nil;
                
                for (NSString *line in lines) {
                    if ([line hasPrefix:@"/* "]) {
                        currentCategory = line;
                        
                        NSMutableArray *strings =
                        stringsByCategory[currentCategory];
                        
                        if (!strings) {
                            strings = [[NSMutableArray alloc] init];
                            stringsByCategory[currentCategory] = strings;
                        }
                    }
                    else if ([line hasPrefix:@"\""]) {
                        NSMutableArray *strings =
                        stringsByCategory[currentCategory];
                        
                        [strings addObject:line];
                    }
                }
                
                NSComparator comparator = (NSComparator)^(NSString *obj1,
                                                          NSString *obj2) {
                    return [obj1 compare:obj2 options:(NSCaseInsensitiveSearch |
                                                       NSDiacriticInsensitiveSearch)];
                };
                
                NSArray *sortedCategories =
                [[stringsByCategory allKeys] sortedArrayWithOptions:NSSortConcurrent
                                                    usingComparator:comparator];
                
                NSMutableString *result = [[NSMutableString alloc] init];
                
                for (NSString *category in sortedCategories) {
                    [result appendString:category];
                    [result appendString:@"\n"];
                    
                    NSArray *sortedStrings =
                    [stringsByCategory[category] sortedArrayWithOptions:NSSortConcurrent
                                                        usingComparator:comparator];
                    
                    for (NSString *string in sortedStrings) {
                        [result appendString:string];
                        [result appendString:@"\n"];
                    }
                    
                    if (![category isEqualToString:[sortedCategories lastObject]]) {
                        [result appendString:@"\n"];
                    }
                }
                
                NSError *writeError = nil;
                
                BOOL didSave = [result writeToFile:args[2]
                                        atomically:YES
                                          encoding:encoding
                                             error:&writeError];
                
                if (!didSave && writeError) {
                    NSLog(@"Error saving file: %@", [writeError localizedDescription]);
                }
            }
            else if (loadError) {
                NSLog(@"Error loading string at %@: %@", path, [loadError localizedDescription]);
            }
        }
    }
    
    return EXIT_SUCCESS;
}

