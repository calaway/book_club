# Audiobook Helpers

Scripts to help process audiobook files.

## Concatenate mp3s

This script is useful when you have multiple mp3 files per chapter. It will
1) concatenate them to give you one file per chapter, and 
2) rename them to the chapter titles.

### Prerequisites

- `ruby`
- `ffmpeg`

### Usage

**Note: Rename all files to remove any colons (`:`) before running script**

#### Basic Usage

```bash
cd path/to/audiobook/mp3s
ruby path/to/contatenate_mp3s.rb track_groups.txt track_titles.txt
```

#### Detailed Usage

First create a file of track groupings by listing all mp3 files. I.e.
```bash
cd path/to/audiobook/mp3s
ls *.mp3 > track_groups.txt
```

Edit the track groups file such all chapters are delimited by a blank new line. So if one chapter is comprised of three mp3s, those three file names should be on ajacent lines with a blank new line before and after. *Do not edit the file names.*

Second, create a file listing the new file names. You typically want these to be something like `01 Name of First Chapter.mp3`.

Third, run the script from the directory containing your mp3s, passing the two files above as arguments.

```bash
cd path/to/audiobook/mp3s
ruby path/to/contatenate_mp3s.rb track_group_file track_titles
```
