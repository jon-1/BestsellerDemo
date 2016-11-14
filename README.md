# BestsellerDemo

This app allows you to see the categories of books on the NY Times best seller list.
If it's your first time logging in, you'll be shown a message that data is being fetched for you. In the future, this won't happen - the persisted data will be shown instead (unless there's an internet problem). Anytime, pulling down on this table view will do a fresh API call.

Selecting a category will bring you to a second page that lists the books in that category. A control at the top allows you to swap what method they're being sorted by. This choice will be saved. Selecting a book will expand the cell to reveal the author, title, description, book cover image, and functioning links to Amazon and the NY Times review (if present, blue, otherwise they'll be blacked out). 

The included 3rd party libraries are Cocoa Pods - Alamofire for network calls, SDWebImage for image caching, Realm for persistence and SwiftyJSON for JSON handling. 

