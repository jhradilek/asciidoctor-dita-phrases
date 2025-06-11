#!/usr/bin/env ruby

# dita-phrases.rb - generate reusable phrases from AsciiDoc attributes
# Copyright (C) 2025 Jaromir Hradilek

# MIT License
#
# Permission  is hereby granted,  free of charge,  to any person  obtaining
# a copy of  this software  and associated documentation files  (the "Soft-
# ware"),  to deal in the Software  without restriction,  including without
# limitation the rights to use,  copy, modify, merge,  publish, distribute,
# sublicense, and/or sell copies of the Software,  and to permit persons to
# whom the Software is furnished to do so,  subject to the following condi-
# tions:
#
# The above copyright notice  and this permission notice  shall be included
# in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS",  WITHOUT WARRANTY OF ANY KIND,  EXPRESS
# OR IMPLIED,  INCLUDING BUT NOT LIMITED TO  THE WARRANTIES OF MERCHANTABI-
# LITY,  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT
# SHALL THE AUTHORS OR COPYRIGHT HOLDERS  BE LIABLE FOR ANY CLAIM,  DAMAGES
# OR OTHER LIABILITY,  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM,  OUT OF OR IN CONNECTION WITH  THE SOFTWARE  OR  THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.

require 'asciidoctor'
require 'dita-topic'
require 'optparse'

# Genral information about the script:
VERSION   = '0.2.1'
NAME      = File.basename($0)

# Set the default options:
opt_id    = 'product-attributes'
opt_title = 'Product attributes'

# Configure the option parser:
parser = OptionParser.new do |opt|
  opt.banner  = "Usage: #{NAME} [-i ID] [-t TITLE] FILE\n"
  opt.banner += "       #{NAME} -h|-v\n\n"

  opt.on('-i', '--id=ID', 'specify the topic id') do |id|
    # Verify that the supplied string is a valid XML ID:
    abort "#{NAME}: Invalid XML ID: #{id}" if id !~ /^[A-Za-z:_][A-Za-z0-9:._-]*$/
    opt_id = id
  end

  opt.on('-t', '--title=TITLE', 'specify the topic title') do |title|
    opt_title = title.encode(:xml => :text)
  end

  opt.on('-h', '--help', 'display this help and exit') do
    # Print usage information to standard output and exit:
    puts opt
    exit
  end

  opt.on('-v', '--version', 'display version information and exit') do
    # Print version information to standard output and exit:
    puts "#{NAME} #{VERSION}"
    exit
  end
end

# Parse command-line options:
args = parser.parse!

# Get the name of the file to process:
file = args[0]

# Verify the number of comman-line arguments:
if args.length == 0
  puts parser.banner
  puts "Run '#{NAME} -h' for more information"
  exit 1
elsif args.length != 1
  abort "#{NAME}: Invalid number of arguments"
end

# Verify that the supplied file exists and is readable:
abort "#{NAME}: File does not exist: #{file}" if not File.exist? file
abort "#{NAME}: Not a file: #{file}" if not File.file? file
abort "#{NAME}: File not readable: #{file}" if not File.readable? file

# Get the list of built-in attributes:
built_in = Asciidoctor.load('', safe: :safe, backend: 'dita-topic').attributes

# Parse the supplied file:
attributes = Asciidoctor.load(File.read(file), safe: :safe, backend: 'dita-topic').attributes

# Compose the document header:
result = [%(<?xml version='1.0' encoding='utf-8' ?>)]
result << %(<!DOCTYPE concept PUBLIC "-//OASIS//DTD DITA Concept//EN" "concept.dtd">)
result << %(<concept id="#{opt_id}">)
result << %(  <title>#{opt_title}</title>)
result << %(  <conbody>)
result << %(    <ul>)

# Process document attributes:
attributes.each do |attr, value|
  # Skip built-in attributes:
  next if built_in.key? attr.downcase

  # Skip attributes that do not have a value:
  next if value.empty?

  # Convert the attribute value to DITA:
  converted = Asciidoctor.convert(value, standalone: false, backend: 'dita-topic', attributes: 'experimental').gsub(/<\/?p>/, '')

  # Compose the phrase line:
  result <<%(      <li><ph id="#{attr}">#{converted}</ph></li>)
end

# Compose the document footer:
result << %(    </ul>)
result << %(  </conbody>)
result << %(</concept>)

# Print the document to standard output:
puts result
