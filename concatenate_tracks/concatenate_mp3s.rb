require 'fileutils'

track_group_file = File.readlines(ARGV[0])
track_titles = File.readlines(ARGV[1]).map(&:chomp)

track_groups = track_group_file.join.split("\n\n").each_with_object([]) { |track_group, accumulator| accumulator << track_group.split("\n") }
if track_groups.count != track_titles.count
  raise "Track count mismatch.\nTrack groups: #{track_groups.count}\nTracks: #{track_titles.count}"
end

processed_directory = 'processed'
FileUtils.rm_rf(processed_directory)
FileUtils.mkdir_p(processed_directory)

track_groups.zip(track_titles) do |track_group, track_title|
  if track_group.count == 1
    `cp "#{track_group.first}" #{processed_directory}/#{track_title.delete_suffix('.mp3').dump}.mp3`
  else
    `ffmpeg -i "concat:#{track_group.join('|')}" -c copy #{processed_directory}/#{track_title.delete_suffix('.mp3').dump}.mp3`
  end
end
