require 'gemoji'

Emoji.all.each do |emoji|
  emoji.aliases.each do |name|
    puts name
  end
end
