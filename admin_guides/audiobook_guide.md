# Audiobook Guide

## Audible

This guide will allow an Audible user to play audiobooks they have purchased via any audiobook player they prefer.

### Convert to MP3:

1. Download an audiobook purchased from Audible
1. Find your Audible activation bytes key be uploading the AAX file to https://audible-tools.kamsker.at/
1. Clone the repo [AAXtoMP3](https://github.com/KrumpetPirate/AAXtoMP3): `git clone https://github.com/KrumpetPirate/AAXtoMP3.git`
1. Install dependencies: `brew install grep findutils gnu-sed ffmpeg mediainfo`
1. Convert the AAX file to MP3 files: `bash AAXtoMP3 --authcode abcd1234 ~/Downloads/my-book.aax`

### Rename Files:

Bulk renaming can be done via a CLI tool called `qmv` and VS Code.
1. Install `qmv`: `brew install renameutils`
1. Navigate to the mp3 directory and open the file names for editing in VS Code: `qmv -e "code -w" -f do`
1. Save and close the file to save

### Edit MP3 Tags

1. Install EasyTAG: `brew install easy-tag`
1. Navigate to the mp3 directory and open it in EasyTAG: `easytag .`

### Zip Directory

To zip the directory without accidentally including MacOS's `.DS_Store` or other hidden files:
1. Navigate to the folder containing the directory to be zipped
1. Replace the directory name (with no trailing slash) and run: `DIRECTORY=Catch-22\ -\ Joseph\ Heller; zip -r "$DIRECTORY (audiobook).zip" $DIRECTORY -x "**/.*" -x "**/__MACOSX"`
1. View archive contents: `zip -sf dir.zip | sort`
