# Audiobook Helpers

Scripts to help process audiobook files.

## Concatenate mp3s

This script is useful when you have multiple mp3 files per chapter. It will 1) concatenate them to give you one file per chapter, and 2) rename them to the chapter titles.

### Prerequisites

- `ruby`
- `ffmpeg`

### Usage

First create a `track_group_file` by listing all mp3 files. I.e.
```bash
cd path/to/audiobook/mp3s
ls *.mp3 > track_group_file.txt
```

```bash
ruby ./concatenate_mp3s.rb track_group_file track_titles
```

`track_group_file` should be a 
