# DB5

by [Q Branch](http://qbranch.co/)

## App Configuration via Plist

By storing colors, fonts, numbers, booleans, and so on in a plist, we were able to iterate quickly on our app [Vesper](http://vesperapp.co/).

Our designers could easily make changes without having to dive into the code or ask engineering to spend time nudging pixels and changing values.

There is nothing magical about the code or the system: it’s some simple code plus a few conventions.

### How it works

See the demo app. You include two classes — `VSThemeLoader` and `VSTheme` — and DB5.plist. The plist is where you set values.

At startup you load the file via `VSThemeLoader`, then access values via methods in `VSTheme`.

#### VSTheme methods

Most of the methods are straightforward. `-[VSTheme boolForKey:]` returns a BOOL, and so on.

Some of the methods require multiple values in the plist file. For instance, `-[VSTheme fontForKey:]` expects the font name as `keyName` and the size as `keyNameSize`. See VSTheme.h for more informatio
