class Transmute

  require 'shellwords'

  attr_reader :current_files, :full_path, :base_path

  def initialize(base_path:nil)
    @current_files = []
    @full_path =nil
    @base_path = base_path || default_base_path
  end

  def check_version
    `ffmpeg -v`
  end

  def default_base_path
    ''
  end

  def strip_subtitles
    create_copy_folder
    cmds = format_file_names.map do |file|
      copy_path = Shellwords.escape(copy_folder)+"/"+File.basename(file)
      "ffmpeg -i #{file} -vcodec copy -acodec copy -sn #{copy_path} -y"
    end
    cmds
  end

  def run_strip_subtitles!
    strip_subtitles.each do |cmd|
      `#{cmd}`
    end
  end

  def remove_prior_folder!
    FileManager.remove_folder(@full_path)
  end

  def get_files(path, ext=nil)
    @full_path = base_path+path

    @current_files = FileManager.get_files(@full_path, ext)
  end

  def format_file_names
    @current_files.map {|x| ::Shellwords.escape(file_path(x))}
  end

  def file_path(file)
    @full_path+"/"+file
  end

  def copy_folder
    @full_path+'-copy'
  end

  def create_copy_folder
    unless Dir.exists? copy_folder
      `mkdir #{Shellwords.escape(copy_folder)}`
    end
  end

  class FileManager

    def self.remove_folder(path)
      `rm -rf #{Shellwords.escape(path)}`
    end

    def self.get_files(path, ext=nil)
      files = Dir.entries(path).reject{|x| x == '.' || x == '..'}
      if ext
        files = files.select{|x| x.include? ext}
      end
      files
    end

  end

  # class FFMpeg

  #   attr_reader :file_path

  #   def initialize(file_path)
  #     @file_path = file_path
  #   end

  #   def self.check_version
  #     `ffmpeg -v`
  #   end

  #   def strip_subtitles!

  #   end

  # end

end