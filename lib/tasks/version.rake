desc 'update the version numbers of the readme file. Use like this: rails "bump_version[0.13.2]" Yes the quotes do matter'
task :bump_version, [:version_number] => :environment do |_, args|
  VERSION_REGEX = /\d+\.\d+\.\d+/
  files=%w(config/initializers/version.rb)
  version_number = args[:version_number]
  puts "New version number is: #{version_number}"
  if VERSION_REGEX.match(version_number)
    files.each do |file_name|
      file = File.read(file_name)
      puts "\nRead in the contents:\n#{file}"
      new_contents = file.gsub(VERSION_REGEX, version_number)
      File.open(file_name, 'w') do |f|
        puts "\nWriting out:\n#{new_contents}"
        f.puts(new_contents)
      end
    end
  else
    puts "The version that was input: #{version_number} did not match the expected pattern defined by the regex: #{VERSION_REGEX}"
  end
end
