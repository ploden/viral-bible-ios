//
//  APIController.swift
//  Viral-Bible-Ios
//
//  Created by Philip Loden on 10/3/15.
//  Copyright © 2015 Alan Young. All rights reserved.
//

import Foundation

class APIController {
    
    class func getLanguages(completion: ((languages: [BibleLanguage]?, error: NSError?) -> ())) -> () {
        let session = NSURLSession.sharedSession()
        
        let components = APIController.APIComponents("/library/volumelanguagefamily")
        let tokenItem = NSURLQueryItem(name: "key", value: APIController.APIKey())
        let versionItem = NSURLQueryItem(name: "v", value: APIController.APIVersion())
        
        components.queryItems = [tokenItem, versionItem]
        
        let url = components.URL
        
        if let url = url {
            let request = NSMutableURLRequest(URL: url)
            
            session.dataTaskWithRequest(request, completionHandler: { (responseData, response, error) -> Void in
                if let responseData = responseData {
                    do {
                        let json = try NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.AllowFragments)
                        
                        var bibleLanguages = [BibleLanguage]()
                        
                        if let languages = json as? [[String : AnyObject]] {
                            for language in languages {
                                if let
                                    name = language["language_family_name"] as? String,
                                    familyCode = language["language_family_code"] as? String
                                {
                                    let bibleLanguage = BibleLanguage(name: name, languageFamilyCode: familyCode)
                                    bibleLanguages.append(bibleLanguage)
                                }
                            }
                        }
                        
                        completion(languages: bibleLanguages, error: nil)
                    } catch {
                        
                    }
                }
            }).resume()
        }
    }
    
    class func getVersions(language: BibleLanguage, completion: ((versions: [BibleVersion]?, error: NSError?) -> ())) -> () {
        let session = NSURLSession.sharedSession()
        
        let components = APIController.APIComponents("/library/volume")
        
        let tokenItem = NSURLQueryItem(name: "key", value: APIController.APIKey())
        let versionItem = NSURLQueryItem(name: "v", value: APIController.APIVersion())
        let mediaItem = NSURLQueryItem(name: "media", value: "text")
        let languageItem = NSURLQueryItem(name: "language_family_code", value: language.languageFamilyCode)
        
        components.queryItems = [tokenItem, versionItem, mediaItem, languageItem]
        
        let url = components.URL
        
        if let url = url {
            let request = NSMutableURLRequest(URL: url)
            
            session.dataTaskWithRequest(request, completionHandler: { (responseData, response, error) -> Void in
                if let responseData = responseData {
                    do {
                        let json = try NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.AllowFragments)
                        
                        var bibleVersions = [BibleVersion]()
                        
                        if let versions = json as? [[String : AnyObject]] {
                            for version in versions {
                                if let
                                    name = version["version_name"] as? String,
                                    familyCode = version["language_family_code"] as? String,
                                    damID = version["dam_id"] as? String
                                {
                                    let bibleVersion = BibleVersion(bibleLanguage: language, name: name, languageFamilyCode: familyCode, damID: damID)
                                    bibleVersions.append(bibleVersion)
                                }
                            }
                        }
                        
                        completion(versions: bibleVersions, error: nil)
                    } catch {
                        
                    }
                }
            }).resume()
        }
    }
    
    class func getBooks(version: BibleVersion, completion: ((books: [BibleBook]?, error: NSError?) -> ())) -> () {
        let session = NSURLSession.sharedSession()
        
        let components = APIController.APIComponents("/library/book")
        
        let tokenItem = NSURLQueryItem(name: "key", value: APIController.APIKey())
        let versionItem = NSURLQueryItem(name: "v", value: APIController.APIVersion())
        let damItem = NSURLQueryItem(name: "dam_id", value: version.damID)
        
        components.queryItems = [tokenItem, versionItem, damItem]
        
        let url = components.URL
        
        if let url = url {
            let request = NSMutableURLRequest(URL: url)
            
            session.dataTaskWithRequest(request, completionHandler: { (responseData, response, error) -> Void in
                if let responseData = responseData {
                    do {
                        let json = try NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.AllowFragments)
                        
                        var bibleBooks = [BibleBook]()
                        
                        if let books = json as? [[String : AnyObject]] {
                            for book in books {
                                if let
                                    name = book["book_name"] as? String,
                                    bookOrder = book["book_order"] as? String,
                                    bookOrderInt = Int16(bookOrder),
                                    numChapters = book["number_of_chapters"] as? String,
                                    numChaptersInt = Int16(numChapters),
                                    bookID = book["book_id"] as? String
                                {
                                    let bibleBook = BibleBook(bibleVersion: version, bookName: name, bookOrder: bookOrderInt, numChapters: numChaptersInt, bookID: bookID)
                                    bibleBooks.append(bibleBook)
                                }
                            }
                        }
                        
                        completion(books: bibleBooks, error: nil)
                    } catch {
                        
                    }
                }
            }).resume()
        }
    }
    
    class func getVerses(book: BibleBook, chapterID: Int16, completion: ((verses: [BibleVerse]?, error: NSError?) -> ())) -> () {
        let session = NSURLSession.sharedSession()
        
        let components = APIController.APIComponents("/text/verse")
        
        let tokenItem = NSURLQueryItem(name: "key", value: APIController.APIKey())
        let versionItem = NSURLQueryItem(name: "v", value: APIController.APIVersion())
        let bookItem = NSURLQueryItem(name: "book_id", value: book.bookID)
        let chapterItem = NSURLQueryItem(name: "chapter_id", value: String(chapterID))
        let damIDItem = NSURLQueryItem(name: "dam_id", value: String(book.bibleVersion.damID))
        
        components.queryItems = [tokenItem, versionItem, bookItem, chapterItem, damIDItem]
        
        let url = components.URL
        
        if let url = url {
            let request = NSMutableURLRequest(URL: url)
            
            session.dataTaskWithRequest(request, completionHandler: { (responseData, response, error) -> Void in
                if let responseData = responseData {
                    //print(String(data: responseData, encoding: NSUTF8StringEncoding))
                    
                    do {
                        let json = try NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.AllowFragments)
                        
                        var bibleVerses = [BibleVerse]()
                        
                        if let verses = json as? [[String : AnyObject]] {
                            for verse in verses {
                                if let
                                    verseID = verse["verse_id"] as? String,
                                    verseIDInt = Int16(verseID),
                                    verseText = verse["verse_text"] as? String
                                {
                                    let bibleVerse = BibleVerse(bibleBook: book, chapterID: chapterID, verseText: verseText, bibleVerseID: verseIDInt, recordings: nil)
                                    bibleVerses.append(bibleVerse)
                                }
                            }
                        }
                        
                        completion(verses: bibleVerses, error: nil)
                    } catch {
                        
                    }
                }
            }).resume()
        }
    }
    
    class func getRecordings(book: BibleBook, chapterID: Int16, completion: ((verses: [BibleVerseRecording]?, error: NSError?) -> ())) -> () {
        
    }
    
    class func uploadRecording(book: BibleBook, chapterID: Int16, fileURL: NSURL, completion: ((error: NSError?) -> ())) -> () {
                
        let data = NSData()
        
        let request = AWSS3PutObjectRequest()
        request.bucket = Helper.S3Bucket()
        request.contentType = "audio/x-caf";
        request.body = data
        request.key = "\(NSUUID().UUIDString).caf"
        request.contentLength = data.length;        
        
        AWSS3.defaultS3().putObject(request).continueWithBlock { (task) -> AnyObject! in
            if let error = task.error {
                // handle error
                print("here is an error")
            } else {
                print("upload succeeded")
            }
            return nil
        }
        
        /*
        NSAssert(data, @"nonnull is nil");
        
        AWSS3 *s3 = [AWSS3 defaultS3];
        
        AWSS3PutObjectRequest *request = [AWSS3PutObjectRequest new];
        request.bucket = [Helper S3Bucket];
        request.contentType = @"image/jpg";
        request.body = data;
        request.key = [NSString stringWithFormat:@"%@.jpg", [[NSUUID UUID] UUIDString]];
        request.contentLength = [NSNumber numberWithInteger:data.length];
        
        [[s3 putObject:request] continueWithBlock:^id(BFTask *task) {
        if (task.error) {
        completion(task.error);
        } else {
        NSURL *baseURL = [[[s3 configuration] endpoint] URL];
        NSURL *bucketURL = [baseURL URLByAppendingPathComponent:[Helper S3Bucket]];
        NSURL *imageURL = [bucketURL URLByAppendingPathComponent:request.key];
        
        NSDictionary *params = @{@"profile_pic_url" : [imageURL absoluteString]};
        NSString *path = @"tippit_users/update_profile_pic";
        
        [[self sharedInstance] dataTaskWithMethod:PRPStoreHTTPMethodPOST remotePath:path responseKeyPath:nil params:params entityName:nil parentObject:nil relationship:nil completion:^(NSArray *data, NSError *error) {
        if ( ! error ) {
        [[UserManager sharedManager] currentUser].profilePicURL = [imageURL absoluteString];
        
        TPTBaseTippitUser *bgCurrent = (TPTBaseTippitUser *)[[[self sharedInstance] backgroundContext] objectWithID:[[[UserManager sharedManager] currentUser] objectID]];
        bgCurrent.profilePicURL = [imageURL absoluteString];
        [self saveContext:[[self sharedInstance] backgroundContext]];
        }
        completion(error);
        }];
        }
        return nil;
        }];
        */
    }
    
    class func recordingsURL(book: BibleBook, chapterID: Int16) -> NSURL {
        // http://viralbible01.s3-website-us-east-1.amazonaws.com
        
        let lang = book.bibleVersion.bibleLanguage.languageFamilyCode
        let version = book.bibleVersion.damID
        let book = book.bookID
        let chapter = chapterID
        
        let filename = "\(lang)_\(version)_\(book)_\(chapter).json"
        
        let components = NSURLComponents()
        components.path = filename
        components.host = "viralbible01.s3-website-us-east-1.amazonaws.com"
        components.scheme = "http"
        
        return components.URL!
    }
    
    class func APIComponents(path: String) -> NSURLComponents {
        let components = NSURLComponents()
        components.path = path
        components.host = APIController.APIHost()
        components.scheme = APIController.APIScheme()
        return components
    }
    
    class func APIKey() -> String {
        return "54070a0ff52e1b5355f0738bb066cf74"
    }
    
    class func APIVersion() -> String {
        return "2"
    }
    
    class func APIHost() -> String {
        return "dbt.io"
    }
    
    class func APIScheme() -> String {
        return "http"
    }
    
}