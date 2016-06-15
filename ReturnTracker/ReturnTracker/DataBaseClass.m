//
//  DataBaseClass.m
//  Return Tracker
//
//  Created by Ranjeeta Rajput on 08/10/13.
//  Copyright (c) 2013 Ranjeeta Rajput. All rights reserved.
//

#import "DataBaseClass.h"
#import <sqlite3.h>

static DataBaseClass *sharedInstance = nil;
static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;
@implementation DataBaseClass
@synthesize delegate;
@synthesize arrRecord;

//Create Share Method of singleton class
+(DataBaseClass*)getSharedInstance{
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL]init];
        //[sharedInstance createDB];
        [sharedInstance findDBPath];
    }
    return sharedInstance;
}


// Method for finding a path
- (void)findDBPath
{
    NSString *databaseName = @"ReturnTrackerDatabase.sqlite";
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [documentPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithFormat:@"%@", [documentsDir stringByAppendingPathComponent:databaseName]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL success = [fileManager fileExistsAtPath:databasePath];
    
    if(!success) {
        NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
        [fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
    }
    
    
    
}

- (void)loadArrayRecord{
    [self.arrRecord removeAllObjects];
    [self receiveAllData];
}

//Receive all Data Which is available in database
-(void)receiveAllData
{
    //NSMutableArray *record = [[NSMutableArray alloc]init];
    if(!self.arrRecord){
        self.arrRecord = [[NSMutableArray alloc]init];
    }
    const char *dbpath=[databasePath UTF8String];
    if (sqlite3_open(dbpath, &database)==SQLITE_OK) {
        NSString *selectSQL=[NSString stringWithFormat:@"select * from product_record"];
        const char *select_stmt=[selectSQL UTF8String];
        int res = sqlite3_prepare_v2(database, select_stmt, -1, &statement, NULL);
        if (res!=SQLITE_OK){
        }
        else{
            
            while(sqlite3_step(statement)==SQLITE_ROW){
                RecordData *recordData=[[RecordData alloc]init];
                recordData.productID=sqlite3_column_int(statement, 0);
                recordData.shopID=[[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 1)]intValue];
               
                
                if (sqlite3_column_text(statement,2)) {
                    recordData.receiptNumberStr=[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 2)];
                }
                if (sqlite3_column_text(statement,3)) {
                    recordData.productNameStr=[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 3)];
                }
                
                
                if (sqlite3_column_text(statement,4)) {
                    recordData.purchaseDateStr=[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 4)];
                }
                
                if (sqlite3_column_text(statement,5)) {
                    recordData.returnDate=[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement,5)];
                    
                }
                if (sqlite3_column_text(statement,6)) {
                    
                    recordData.notes=[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 6)];
                }
//                if (sqlite3_column_bytes(statement, 7)>0) {
//                    int length = sqlite3_column_bytes(statement, 7);
//                    NSData *image1 = [NSData dataWithBytes:sqlite3_column_blob(statement, 7) length:length];
//                    
//                    recordData.img1=[UIImage imageWithData:image1];
//                }
//                if (sqlite3_column_bytes(statement,8)>0) {
//                    int length = sqlite3_column_bytes(statement,8);
//                    NSData *image2 = [NSData dataWithBytes:sqlite3_column_blob(statement,8) length:length];
//                    recordData.img2=[UIImage imageWithData:image2];
//                }
//                
//                if (sqlite3_column_bytes(statement, 9)>0) {
//                    int length = sqlite3_column_bytes(statement, 9);
//                    NSData *image3 = [NSData dataWithBytes:sqlite3_column_blob(statement,9) length:length];
//                    recordData.img3=[UIImage imageWithData:image3];
//                    
//                    
//                }
//                
//                if (sqlite3_column_bytes(statement, 10)) {
//                    int length= sqlite3_column_bytes(statement, 10);
//                    NSData *image4 = [NSData dataWithBytes:sqlite3_column_blob(statement, 10) length:length];
//                    recordData.img4=[UIImage imageWithData:image4];
//                    
//                }
                //ran change
                recordData.productReturnedStatus= sqlite3_column_int64(statement, 11);
                
                if (sqlite3_column_text(statement,12)) {
                    recordData.returnAlertDate=[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 12)];
                }
                [self.arrRecord addObject:recordData];
                
                [recordData release];
            }
        }
        
    }
    
    sqlite3_close(database);
    //return self.arrRecord;
    
}

- (BOOL) saveData:(RecordData *)recordInfo{
    
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        //ran change
        const char *insert_stmt = "insert into product_record(shop_id,product_name,reciept_no,purchase_date,return_date,notes,product_image1,product_image2,product_image3,product_image4,product_status,alert_date) VALUES (?,?,?,?,?,?,?,?,?,?,?,?)";
        sqlite3_stmt* statement;
      
        
        
        if( sqlite3_prepare_v2(database, insert_stmt, -1, &statement, NULL) == SQLITE_OK )
        {
            
            sqlite3_bind_int(statement,1, [recordInfo shopID]);
            sqlite3_bind_text(statement,2, [[recordInfo productNameStr] UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement,3, [[recordInfo receiptNumberStr] UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 4, [[recordInfo purchaseDateStr] UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 5, [[recordInfo returnDate] UTF8String], -1, SQLITE_TRANSIENT);
            
            sqlite3_bind_text(statement, 6, [[recordInfo notes] UTF8String], -1, SQLITE_TRANSIENT);
            
            
            if ([recordInfo img1]!=NULL) {
               // UIImagePNGRepresentation
//                NSData *data=UIImagePNGRepresentation([recordInfo img1]);
//                sqlite3_bind_blob(statement, 7, [[recordInfo image1]bytes], [[recordInfo image1]length], SQLITE_TRANSIENT);
                sqlite3_bind_blob(statement, 7, [UIImagePNGRepresentation([recordInfo img1]) bytes],  [UIImagePNGRepresentation([recordInfo img1]) length], SQLITE_TRANSIENT);
            }
            if ([recordInfo img2]!=NULL) {
                NSData *image2=UIImagePNGRepresentation([recordInfo img2]);
//                sqlite3_bind_blob(statement, 8, [[recordInfo image2]bytes], [[recordInfo image2]length], SQLITE_TRANSIENT);
                sqlite3_bind_blob(statement, 8, [image2 bytes], [image2 length], SQLITE_TRANSIENT);
            }
            if ([recordInfo img3]!=NULL) {
                NSData *image3=UIImagePNGRepresentation([recordInfo img3]);
                sqlite3_bind_blob(statement,9, [image3 bytes],[image3 length], SQLITE_TRANSIENT);
//                sqlite3_bind_blob(statement,9, [[recordInfo image3]bytes], [[recordInfo image3]length], SQLITE_TRANSIENT);
            }
            if ([recordInfo img4]!=NULL) {
                NSData *image4=UIImagePNGRepresentation([recordInfo img4]);
                sqlite3_bind_blob(statement,10, [image4 bytes], [image4 length], SQLITE_TRANSIENT);
               // sqlite3_bind_blob(statement, 10, [[recordInfo image4]bytes], [[recordInfo image4]length], SQLITE_TRANSIENT);
            }
            int productReturnValue=0;
            sqlite3_bind_int(statement,11, productReturnValue);
            if (recordInfo.returnAlertDate) {
                sqlite3_bind_text(statement, 12, [[recordInfo returnAlertDate] UTF8String], -1, SQLITE_TRANSIENT);
            }
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_close(database);
                [self loadArrayRecord];
                return YES;
            }
            else {
                sqlite3_close(database);
                
                return NO;
            }
            sqlite3_finalize(statement);
            sqlite3_close(database);
            [self loadArrayRecord];
            return YES;
            
        }else
        {
            NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
            return NO;
            
        }
        
        
        
        
        
    }
    [self loadArrayRecord];
    return YES;
}
- (BOOL) updateData:(RecordData *)recordInfo{
    
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        
        
        
        const char *update_stmt="update product_record set shop_id = ?, product_name = ?,purchase_date=?,return_date=?,notes=?,product_image1=?,product_image2=?,product_image3=?,product_image4=?,product_status=?,alert_date=? Where pid = ?";
        
        if( sqlite3_prepare_v2(database, update_stmt, -1, &statement, NULL) == SQLITE_OK )
        {
            sqlite3_bind_int(statement,1, [recordInfo shopID]);
            
            sqlite3_bind_text(statement,2, [[recordInfo productNameStr] UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 3, [[recordInfo purchaseDateStr] UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 4, [[recordInfo returnDate] UTF8String], -1, SQLITE_TRANSIENT);
            
            sqlite3_bind_text(statement, 5, [[recordInfo notes] UTF8String], -1, SQLITE_TRANSIENT);
            
            
            if ([recordInfo img1]!=NULL) {
                NSData *image1=UIImagePNGRepresentation([recordInfo img1]);
                sqlite3_bind_blob(statement, 6, [image1 bytes], [image1 length], SQLITE_TRANSIENT);
            }
            if ([recordInfo img2]!=NULL) {
                NSData *image2=UIImagePNGRepresentation([recordInfo img2]);
                sqlite3_bind_blob(statement, 7, [image2 bytes], [image2 length], SQLITE_TRANSIENT);
            }
            if ([recordInfo img3]!=NULL) {
                NSData *image3=UIImagePNGRepresentation([recordInfo img3]);
                sqlite3_bind_blob(statement,8, [image3 bytes], [image3 length], SQLITE_TRANSIENT);
            }
            if ([recordInfo img4]!=NULL) {
                NSData *image4=UIImagePNGRepresentation([recordInfo img4]);
                sqlite3_bind_blob(statement, 9, [image4 bytes], [image4 length], SQLITE_TRANSIENT);
            }
            sqlite3_bind_int(statement,10, [recordInfo productReturnedStatus]);
            if (recordInfo.returnAlertDate) {
                sqlite3_bind_text(statement, 11, [[recordInfo returnAlertDate] UTF8String], -1, SQLITE_TRANSIENT);
            }
            
            sqlite3_bind_int(statement,12, [recordInfo productID]);
           // sqlite3_bind_text(statement,11, [[recordInfo receiptNumberStr] UTF8String], -1, SQLITE_TRANSIENT);
            //ran change
            
            
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_close(database);
                [self loadArrayRecord];
                return YES;
            }
            else {
                sqlite3_close(database);
                
                return NO;
            }
            sqlite3_finalize(statement);
            sqlite3_close(database);
            [self loadArrayRecord];
            return YES;
            
            
        }else
        {
            NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
            return NO;
        }
        
        
        
        
        
    }
    [self loadArrayRecord];
    return YES;
}
//
- (BOOL) deleteData:(int)productId{
    
    BOOL success=NO;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        
        
        NSString *deleteSQL = [NSString stringWithFormat: @"delete from product_record where pid=%i",productId];
        const char *sql = [deleteSQL UTF8String];
        
        
        
        if(sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK)
        {
            //sqlite3_bind_text(statement, 1, [receiptNo UTF8String], -1, SQLITE_STATIC);
            sqlite3_bind_int(statement, 1, productId);
            if(SQLITE_DONE != sqlite3_step(statement))
            {
                success=NO;
            }
            else
            {
                [self loadArrayRecord];
                success=YES;
            }
            
        }
        sqlite3_finalize(statement);
        sqlite3_close(database);
        [self loadArrayRecord];
        return success;
        
    }
    return NO;
}


//For Getting last Record
-(int)getMaxId
{
   // NSString *getId=@"SELECT MAX(pid) FROM product_record";
   // const char *dbpath=[databasePath UTF8String];
    
    //
    int lastRecord=0;
    //NSMutableArray *record = [[NSMutableArray alloc]init];
    const char *dbpath=[databasePath UTF8String];
    if (sqlite3_open(dbpath, &database)==SQLITE_OK) {
        NSString *selectSQL=[NSString stringWithFormat:@"SELECT MAX(pid) FROM product_record"];
        const char *select_stmt=[selectSQL UTF8String];
        int res = sqlite3_prepare_v2(database, select_stmt, -1, &statement, NULL);
        if (res!=SQLITE_OK){
        }
        else{
            
            while(sqlite3_step(statement)==SQLITE_ROW){
                lastRecord=sqlite3_column_int(statement, 0);
                //recordData.productID=sqlite3_column_int(statement, 0);
            }
        }
    }
    return lastRecord;
}


//For HomePage Controller
- (BOOL)saveStoreDataWithName:(NSString*)storeName Description:(NSString*)desc Image:(UIImage*)img{
    NSString *imgPath = [[AppDelegate sharedAppDelegate] getNextImageName];
    [UIImagePNGRepresentation(img) writeToFile:imgPath atomically:NO];
    imgPath = [[imgPath componentsSeparatedByString:@"/"] lastObject];
    
    //
    
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        //ran change
        const char *insert_stmt = "insert into stores(shop_name,description,image_path) VALUES (?,?,?)";
        sqlite3_stmt* statement;
        
        
        
        if( sqlite3_prepare_v2(database, insert_stmt, -1, &statement, NULL) == SQLITE_OK )
        {
            
            //sqlite3_bind_int(statement,1, [recordInfo shopID]);
            sqlite3_bind_text(statement,1, [storeName UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement,2, [desc UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 3, [imgPath UTF8String], -1, SQLITE_TRANSIENT);
            //sqlite3_bind_int(statement, 4, [])

            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_close(database);
                [self loadStoreArr];
                return YES;
            }
            else {
                sqlite3_close(database);
                
                return NO;
            }
            sqlite3_finalize(statement);
            sqlite3_close(database);
            [self loadStoreArr];
            return YES;
            
        }else
        {
            NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
            return NO;
            
        }
        
        
        
        
        
    }
  
    return YES;
}


- (BOOL) updateHomePageData:(StoreData *)info
{
    
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        BOOL success=NO;
        
        const char *update_stmt="update stores set shop_name= ?,description=?,image_path=?,favourite=? Where shop_id = ?";
        
        if( sqlite3_prepare_v2(database, update_stmt, -1, &statement, NULL) == SQLITE_OK )
        {
            
            sqlite3_bind_text(statement,1, [[info shopName] UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 2, [[info description] UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 3, [[info imagePath] UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_int(statement,5, [info shopId]);
            sqlite3_bind_int(statement,4, [info favourite]);
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_close(database);
                [self loadStoreArr];
                success=YES;
            }
            else {
                sqlite3_close(database);
                
                success=NO;
            }
            sqlite3_finalize(statement);
            sqlite3_close(database);
           [self loadStoreArr];
            return success;
            
            
        }else
        {
            NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
            return success;
        }
        
        
        
        
        
    }
//[self loadArrayRecord];
    return YES;


}
-(void)receiveHomePageData
{
    if(![AppDelegate sharedAppDelegate].cellItemArr){
        [AppDelegate sharedAppDelegate].cellItemArr = [[NSMutableArray alloc]init];
    }
    const char *dbpath=[databasePath UTF8String];
    if (sqlite3_open(dbpath, &database)==SQLITE_OK) {
        NSString *selectSQL=[NSString stringWithFormat:@"select * from stores"];
        const char *select_stmt=[selectSQL UTF8String];
        int res = sqlite3_prepare_v2(database, select_stmt, -1, &statement, NULL);
        if (res!=SQLITE_OK){
        }
        else{
            
            while(sqlite3_step(statement)==SQLITE_ROW){
                StoreData *recordData=[[StoreData alloc]init];
                recordData.shopId=sqlite3_column_int(statement, 0);
                
                if (sqlite3_column_text(statement,1)) {
                    recordData.shopName=[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 1)];
                }
                if (sqlite3_column_text(statement,2)) {
                    recordData.description=[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 2)];
                }
                
                
                if (sqlite3_column_text(statement,3)) {
                    recordData.imagePath=[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 3)];
                }
            
                recordData.favourite=sqlite3_column_int(statement, 4);

               
                
                [[AppDelegate sharedAppDelegate].cellItemArr addObject:recordData];
                
                [recordData release];
            }
        }
        
    }
    
    sqlite3_close(database);

}


-(void)loadStoreArr
{
    if ([[AppDelegate sharedAppDelegate].cellItemArr count]>0) {
        [[AppDelegate sharedAppDelegate].cellItemArr removeAllObjects];

    }
    [self receiveHomePageData];
}

- (BOOL) deleteStoredData:(int)shopId;
{
    [self deleteProductData:shopId];
    BOOL success=NO;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        
        
        NSString *deleteSQL = [NSString stringWithFormat: @"delete from stores where shop_id=%i",shopId];
        const char *sql = [deleteSQL UTF8String];
        
        
        
        if(sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK)
        {
            //sqlite3_bind_text(statement, 1, [receiptNo UTF8String], -1, SQLITE_STATIC);
            sqlite3_bind_int(statement, 1, shopId);
            if(SQLITE_DONE != sqlite3_step(statement))
            {
                success=NO;
            }
            else
            {
                [self loadStoreArr];
                success=YES;
            }
            
        }
        sqlite3_finalize(statement);
        sqlite3_close(database);
        [self loadStoreArr];
        return success;
        
    }
    return NO;

}
- (BOOL) deleteProductData:(int)shopId{
    
    BOOL success=NO;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        
        
        NSString *deleteSQL = [NSString stringWithFormat: @"delete from product_record where shop_id=%i",shopId];
        const char *sql = [deleteSQL UTF8String];
        
        
        
        if(sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK)
        {
            //sqlite3_bind_text(statement, 1, [receiptNo UTF8String], -1, SQLITE_STATIC);
            sqlite3_bind_int(statement, 1, shopId);
            if(SQLITE_DONE != sqlite3_step(statement))
            {
                success=NO;
            }
            else
            {
                [self loadArrayRecord];
                success=YES;
            }
            
        }
        sqlite3_finalize(statement);
        sqlite3_close(database);
        [self loadArrayRecord];
        return success;
        
    }
    return NO;
}


@end
