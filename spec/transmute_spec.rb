require 'transmute'
require 'pry'

RSpec.describe Transmute do

  let(:transmute) { Transmute.new(base_path: "spec/dev/test with spaces/child") }

  describe '#get_files' do
    it 'returns files in path' do
      expect(transmute.get_files('')).to eq (["extras", "file 3.avi", "file.avi", "file2.avi"])
    end

    it 'returns only files with optional extension passed' do
      expect(transmute.get_files('', 'avi')).to eq (["file 3.avi", "file.avi", "file2.avi"])
    end
  end

  describe 'format_file_names' do
    it 'unix escapes file paths so cli tools can properly read the file names' do
      prepare!
      expect(transmute.format_file_names).to eq (["spec/dev/test\\ with\\ spaces/child/file\\ 3.avi", "spec/dev/test\\ with\\ spaces/child/file.avi", "spec/dev/test\\ with\\ spaces/child/file2.avi"])
    end
  end

  describe 'strip_subtitles' do
    it 'builds command that strips subtitles' do
      prepare!
      expect(transmute.strip_subtitles.first).to eq (
        "ffmpeg -i spec/dev/test\\ with\\ spaces/child/file\\ 3.avi -vcodec copy -acodec copy -sn spec/dev/test\\ with\\ spaces/child-copy/file\\ 3.avi -y")
    end
  end

  describe 'create_copy_folder' do
    it '' do
      prepare!
      transmute.create_copy_folder
      expect(Dir.exist? 'spec/dev/test with spaces/child-copy').to be true
      `rm -rf spec/deb/test\ with\ spaces/child-copy`
    end
  end

  describe 'remove_prior_folder!' do
    it 'removes specified folder' do
      unless Dir.exists? transmute.base_path+"/extras"
        `mkdir #{transmute.base_path}/extras`
      end
      transmute.remove_prior_folder!
    end
  end

  def prepare!
    transmute.get_files('', 'avi')
  end
end