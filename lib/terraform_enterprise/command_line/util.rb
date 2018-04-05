require 'rubygems/package'
require 'zlib'
require 'fileutils'

module TerraformEnterprise
  module CommandLine
    module Util
      # Module to perform a tar and gz of a directory
      module Tar
        def tar(path)
          tarfile = StringIO.new('')
          Gem::Package::TarWriter.new(tarfile) do |tar|
            Dir[File.join(path, '**/*')].each do |file|
              mode          = File.stat(file).mode
              relative_file = file.sub /^#{Regexp.escape(path)}\/?/, ''
              
              if File.directory?(file)
                tar.mkdir relative_file, mode
              else
                tar.add_file relative_file, mode do |tf|
                  File.open(file, 'rb') { |f| tf.write f.read }
                end
              end
            end
          end
          
          tarfile.rewind
          tarfile
        end
        
        def gzip(tarfile)
          gzip_string = StringIO.new('')
          gzip_writer = Zlib::GzipWriter.new(gzip_string)
          gzip_writer.write tarfile.string
          gzip_writer.close
          gzip_string.string
        end

        def tarball(path)
          full_path = File.expand_path(path)
          if File.directory?(full_path)
            gzip(tar(full_path))
          else
            File.read(full_path)
          end
        end
      end
    end
  end
end
