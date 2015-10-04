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
                  let bibleVerse = BibleVerse(verseText: verseText, verseID: verseIDInt)
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