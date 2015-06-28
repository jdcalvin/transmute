class Transmute < Thor

    
    desc "convert_folder", "checks all contents of folder and reformats to specified file format"
    method_option :recursive, :aliases => '-R', :desc => 'change files in folder subfolders'
    method_option :file_type, :aliases => '-ft', :desc => "pass file type, options = '.mp4', '.avi', '.mp3', '.mov', '.mpeg'"
    def convert_folder(path)
      return puts 'Invalid path' if !Dir.exist?(path)
      
      get_files(path).each do |f|
        child_path = "#{path}/#{f}"
        transmute_file(child_path)
      end
      # -R recursive
    end

    private

    def transmute_file(path) 
      puts path
      
        if File.file?(path)

          extension = File.extname(path)
          if extension == '.avi'
            run_ffmpeg(path)
            puts 'Done'
          else
            puts 'Not converting '+path
          end
        else
          puts 'Not a valid file'
        end
        
    end

    def run_ffmpeg(path)
      escape_path = unix_escape(path)
      new_path = escape_path.gsub(extension, '.mp4')
      puts 'Converting '+path
      system "ffmpeg -i #{escape_path} -vcodec copy -acodec copy #{new_path}"
    end

    def sanitize_path(path)
      path.gsub("'","")
    end

    def get_files(path)
      Dir.entries(path).reject{|x| x == '.' || x == '..'}
    end

    def unix_escape(path)
      path.gsub(' ', '\ ')
    end
    
  end
