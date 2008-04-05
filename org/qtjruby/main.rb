file_name = ARGV.first

if File.exist? file_name
  require ARGV.first
else
  puts 'File not found.'
end