require 'gemoji'
require 'plist'

snippets = []

Emoji.all.each do |emoji|
  next if emoji.custom?
  emoji.aliases.each do |name|
    snippet = ":#{name}:"
    snippets.push({shortcut: snippet, phrase: emoji.raw})
  end
end

File.open("emoji.plist", "w") do |f|
  f.write(snippets.to_plist)
end
