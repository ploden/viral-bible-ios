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

                        /*
                        self.getRecordings(book, chapterID: chapterID, completion: { (verses, error) -> () in
                            if let _ = error {
                                completion(verses: nil, error: error)
                            } else {
                                // add to the verses
                                completion(verses: bibleVerses, error: nil)
                            }
                        })
                        */
                    } catch {
                        completion(verses: nil, error: NSError(domain: "VBErrorDomain", code: 0, userInfo: nil))
                    }
                } else {
                    completion(verses: nil, error: NSError(domain: "VBErrorDomain", code: 0, userInfo: nil))
                }
            }).resume()
        }
    }
    
    class func getRecordings(book: BibleBook, chapterID: Int16, completion: ((verses: [BibleVerseRecording]?, error: NSError?) -> ())) -> () {
        let url = self.recordingsURL(book, chapterID: chapterID)
        let request = NSMutableURLRequest(URL: url)
        
        let session = NSURLSession.sharedSession()
        
        session.dataTaskWithRequest(request, completionHandler: { (responseData, response, error) -> Void in
            if let responseData = responseData {
                //print(String(data: responseData, encoding: NSUTF8StringEncoding))
                
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.AllowFragments)
                    
                    var recordings = [BibleVerseRecording]()
                    
                    if let recordingDicts = json as? [[String : AnyObject]] {
                        for recordingDict in recordingDicts {
                            if let
                                recordingURL = recordingDict["verse_id"] as? String
                            {
                                //bibleVerses.append(bibleVerse)
                            }
                        }
                    }
                } catch {
                    
                }
            }
        }).resume()
    }
    
    class func uploadRecording(book: BibleBook, chapterID: Int16, bibleVerseID : Int16, fileURL: NSURL, completion: ((error: NSError?) -> ())) -> () {
        
        let data = NSData(contentsOfURL: fileURL)!
        
        let filename = "\(NSUUID().UUIDString).caf"
        let bucket = Helper.S3Bucket()
        let contentType = "audio/x-caf"
        
        VBUploadController.uploadData(data, filename: filename, bucket: bucket, contentType: contentType, completion: { error in
            if let _ = error {
                // error handling
            } else {
                self.getRecordings(book, chapterID: chapterID, completion: { (verses, error) -> () in
                    if let _ = error {
                        // error handling
                    } else {
                        var mutableVerses : [BibleVerseRecording]
                        
                        if verses == nil {
                            mutableVerses = [BibleVerseRecording]()
                        } else {
                            mutableVerses = verses!
                        }
                        
                        let url = self.recordingsURL(book, chapterID: chapterID)
                        let newRecording = BibleVerseRecording(recordingURL: url, bibleVerseID: bibleVerseID)
                        mutableVerses.append(newRecording)
                        
                        if let any = mutableVerses as? AnyObject {
                            do {
                                let jsonData = try NSJSONSerialization.dataWithJSONObject(any, options: NSJSONWritingOptions.PrettyPrinted)
                                print(String(data: jsonData, encoding: NSUTF8StringEncoding))
                                let filename = self.recordingsFilename(book, chapterID: chapterID)
                                VBUploadController.uploadData(jsonData, filename: filename, bucket: Helper.S3Bucket(), contentType: "text/json", completion: { error in
                                    
                                })
                            } catch {
                                
                            }
                        }
                    }
                })
            }
        })
    }

    class func recordingsFilename(book: BibleBook, chapterID: Int16) -> String {
        let lang = book.bibleVersion.bibleLanguage.languageFamilyCode
        let version = book.bibleVersion.damID
        let book = book.bookID
        let chapter = chapterID
        
        let filename = "\(lang)_\(version)_\(book)_\(chapter).json"
        
        return filename
    }

    class func recordingsURL(book: BibleBook, chapterID: Int16) -> NSURL {
        // http://viralbible01.s3-website-us-east-1.amazonaws.com
        
        let filename = self.recordingsFilename(book, chapterID: chapterID)
        
        let components = NSURLComponents()
        components.path = "/\(filename)"
        components.host = "viralbible01.s3.amazonaws.com"
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