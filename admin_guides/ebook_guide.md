Book club, audiobooks, ebooks

# Ebook Admin Guide

## One-time setup
1. Install Adobe Digital Editions
    1. Download [here](https://www.adobe.com/solutions/ebook/digital-editions/download.html)
    2. When asked to authorize, choose authorize without an ID
2. Install Calibre
    1. Download [here](https://calibre-ebook.com/download)
    2. Go to preferences >> Run Setup Wizard and choose generic smart phone (or whatever you prefer) for your device
3. Install the [DeDRM_tools](https://github.com/noDRM/DeDRM_tools) Calibre plugin
    1. Download latest release zip file [here](https://github.com/noDRM/DeDRM_tools/releases)
    2. Unzip and follow the instructions in the readme to install

## Each book
1. If from the library:
    1. Search book on OverDrive: https://slcpl.overdrive.com/
    2. Download ebook
2. If from Google Books:
    1. Download from https://play.google.com/books >> Library >> Book dot menu >> Export >> Export ACSM for EPUB
3. Open .acsm file with Adobe Digital Editions, then close the app once the book is imported and open
4. Find the encrypted epub in `~/Documents/Digital Editions/` and open it with Calibre
5. Find the decrypted epub in `~/Media/Ebooks/Calibre/`
