Book club, audiobooks, ebooks

# Ebook Admin Guide

## One-time setup
1. Install Adobe Digital Editions
    1. Download [here](https://www.adobe.com/solutions/ebook/digital-editions/download.html), install, and open application
    1. When asked to authorize, log in with an existing Adobe ID or create one (note that you can choose to authorize without an ID, but you’ll risk losing access to books if you lose access to that particular machine)
           1. Creating an Adobe ID should be done without using any of the Federated Login options. Adobe Digital Editions will not allow those for authorization.
    1. You can now close the application
1. Install Calibre
    1. Download [here](https://calibre-ebook.com/download), install, and open application
    1. Go to preferences >> Run Setup Wizard and choose generic smart phone (or whatever you prefer) for your device
    1. You can now close the application
1. Install the [DeDRM_tools](https://github.com/noDRM/DeDRM_tools) Calibre plugin
    1. Download latest release zip file [here](https://github.com/noDRM/DeDRM_tools/releases)
    1. Unzip and follow the instructions in the readme to install

## Each book
1. If from the public library:
    1. Search book on OverDrive: https://slcpl.overdrive.com/
    1. Download ebook as an `.acsm` file
1. If from Google Books:
    1. Download from https://play.google.com/books >> Library >> book's dot menu >> Export >> Export ACSM for EPUB
1. Open the `.acsm` file with Adobe Digital Editions, wait for the book to be imported and open, then close the application
1. Find the _encrypted_ epub file in `~/Documents/Digital Editions/` and open it with Calibre, wait for the book to be imported and open, then close the application
1. Find the _decrypted_ epub file in `~/Media/Ebooks/Calibre/` and open in your preferred ebook reader
1. Optional: If you need to manipulate the decrypted file in any way, first copy it to a new directory, since Calibre manages that one and will overwrite any changes
1. Optional: Return ebook to the library for the next person in queue
