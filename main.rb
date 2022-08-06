require 'gemoji'
require "sqlite3"

user = ENV['USER']
paths = Dir.glob("/Users/#{user}/Library/Dictionaries/CoreDataUbiquitySupport/#{user}*/UserDictionary/local/store/UserDictionary.db")

return if paths.nil? or paths.length != 1

db = SQLite3::Database.new(paths.first)
db.execute("DELETE FROM 'ZUSERDICTIONARYENTRY';")

id = 1
Emoji.all.each do |emoji|
  next if emoji.custom?
  emoji.aliases.each do |name|
    snippet = ":#{name.gsub('_', ' ')}:"
    puts "Adding #{emoji.raw} as #{snippet}..."
    item = "{on=1;replace=\"#{snippet}\";with=\"#{emoji.raw}\";}"
    system("defaults write -g NSUserDictionaryReplacementItems -array-add '#{item}'")
    db.execute("INSERT INTO 'ZUSERDICTIONARYENTRY' VALUES(?, 1,1,0,0,0,0, ?,NULL,NULL,NULL,NULL,NULL, ?, ?,NULL);", [id, Time.now.to_i, snippet, emoji.raw])
    id += 1
  end
end

puts "Loading changes..."
system("defaults read -g NSUserDictionaryReplacementItems")
system("killall cfprefsd")
puts "Done!"
