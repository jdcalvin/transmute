# transmute
Ruby wrapper for ffmpeg to batch convert/extract data from media files

`require 'transmute'`

Initialize an object that points to folder path
`t = Transmute.new(base_path: "full/path/to/folder")`

Specify a folder to look up files in a folder path, with optional extension parameter:

t.get_files('avi_files', '.mkv')

Extract all subtitles from a file with ffmpeg, creating a copy folder and removing the original
t.run_strip_subtitles!
