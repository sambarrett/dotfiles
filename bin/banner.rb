#!/usr/bin/env ruby

require 'yaml'

fail "Usage: ./banner.rb pubinfo.yml paper.ps" if ARGV.size != 2

infofile = ARGV.shift

fail "No pub. info file found" unless File.exists?(infofile)
fail "Pub. info file not readable" unless File.readable?(infofile)

pubinfo = File.open(infofile) do |f|
            YAML.load(f.readlines.join)
          end
fail "No name provided for publication" unless pubinfo['name']

puts "Adding Banner:"
puts "------------------------------"

r = "gsave initmatrix\n60 770 moveto\n/Courier findfont 9 scalefont setfont"
if pubinfo['to_appear']
  r += "\n(To appear in ) show"
  print "To appear in "
else
  r += "\n(In ) show"
  print "In "
end

infostr = []

if pubinfo['volume'] # this is a journal
  infostr[0] = pubinfo['volume'].to_s
  infostr[0] += "(#{pubinfo['number']})" if pubinfo['number']
  infostr[0] += ':' + pubinfo['pages'] if pubinfo['pages']
elsif pubinfo['publisher'] # this is a book
  if pubinfo['editor']
    editorstring = pubinfo['editor']
    editorstring.chop! if editorstring[-1].chr == '.' #et al.?
    editorstring += ', editor'
    editorstring += 's' if pubinfo['editor'] =~ /,|\s(and\s|et\sal)/ #plural?
    r += "\n(#{editorstring}, ) show"
    print "#{editorstring}, "
  end
  infostr.push 'pp. ' + pubinfo['pages'].to_s if pubinfo['pages']
  infostr.push pubinfo['publisher']
  infostr.push pubinfo['loc'] if pubinfo['loc']
else # conference or workshop
  infostr.push 'pp. ' + pubinfo['pages'] if pubinfo['pages']
  infostr.push pubinfo['loc'] if pubinfo['loc']
end

if pubinfo['year']
  if pubinfo['month']
    infostr.push "#{pubinfo['month']} #{pubinfo['year']}."
  else
    infostr.push "#{pubinfo['year']}."
  end
end

r += "\n/Times-Oblique findfont 9 scalefont setfont"
print "/"
r += "\n(#{pubinfo['name']}) show"
print pubinfo['name']
r += "\n/Courier findfont 9 scalefont setfont"
print "/"
if pubinfo['abbr']
  r += "\n( (#{pubinfo['abbr']})) show"
  print " (#{pubinfo['abbr']})"
end
if pubinfo['series']
  r += "\n(, #{pubinfo['series']}) show"
  print ", #{pubinfo['series']}"
end
r += "\n(,) show"
puts ","
r += "\n60 760 moveto"
unless infostr.empty?
  r += "\n(#{infostr.join(', ')}) show"
  puts infostr.join(', ')
end
r += "\ngrestore"
puts "------------------------------"

$-i = ''

found = false
ARGF.each do |line|
  if found # Make sure we only do the first page
    puts line
  else
    puts line.gsub(/%%Page: 1 1/, "%%Page: 1 1\n" + r)
  end
  found = true if line =~ /%%Page: 1 1/
end

unless found
  err_msg = <<EOT
Could not find first page on which to put banner.  Make sure your file contains
the text "%%Page: 1 1" where the first page starts.
EOT
  fail err_msg.chomp
end

