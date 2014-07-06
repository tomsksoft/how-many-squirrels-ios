/*
 * How many squirrels: tool for young naturalist
 *
 * This application is created within the internship
 * in the Education Department of Tomsksoft, http://tomsksoft.com
 * Idea and leading: Sergei Borisov
 *
 * This software is licensed under a GPL v3
 * http://www.gnu.org/licenses/gpl.txt
 *
 * Created by Anton Tsygantsev on 18/06/14
 */

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface HMOSQParametr : NSManagedObject

@property (nonatomic, retain) NSString * def;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSSet *value;
@end

@interface HMOSQParametr (CoreDataGeneratedAccessors)

- (void)addValue:(NSSet *)values;
- (void)removeValue:(NSSet *)values;

@end
