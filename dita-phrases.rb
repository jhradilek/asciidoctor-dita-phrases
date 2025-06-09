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
require 'optparse'

# Genral information about the script:
VERSION   = '0.1.0'
NAME      = File.basename($0)

# Set the default options:
opt_id    = 'product-attributes'
opt_title = 'Product attributes'

# Configure the option parser:
parser = OptionParser.new do |opt|
  opt.banner  = "Usage: #{NAME} [-g GUID] [-i ID] [-t TITLE] FILE\n"
  opt.banner += "       #{NAME} -h|-v\n\n"

  opt.on('-i', '--id=ID', 'specify the topic id') do |id|
    opt_id = id
  end

  opt.on('-t', '--title=TITLE', 'specify the topic title') do |title|
    opt_title = title
  end

  opt.on('-h', '--help', 'display this help and exit') do
    puts opt
    exit
  end

  opt.on('-v', '--version', 'display version information and exit') do
    puts "#{NAME} #{VERSION}"
    exit
  end
end

# Parse command-line options:
args = parser.parse!

# Get the name of the file to process:
file = args[0]

# Verify the number of comman-line arguments:
abort "#{NAME}: Invalid number of arguments" if args.length != 1

# Verify that the supplied file exists and is readable:
abort "#{NAME}: File does not exist: #{file}" if not File.exist? file
abort "#{NAME}: Not a file: #{file}" if not File.file? file
abort "#{NAME}: File not readable: #{file}" if not File.readable? file

# Get the list of built-in attributes:
built_in = Asciidoctor.load('', safe: :safe).attributes

# Parse the supplied file:
attributes = Asciidoctor.load(File.read(file), safe: :safe).attributes

# Compose the document header:
result = [%(<?xml version='1.0' encoding='utf-8' ?>)]
result << %(<!DOCTYPE concept PUBLIC "-//OASIS//DTD DITA Concept//EN" "concept.dtd">)
result << %(<concept id="#{opt_id}">)
result << %(  <title>#{opt_title}</title>)
result << %(  <conbody>)

# Process document attributes:
attributes.each do |attr, value|
  result <<%(    <p><ph id="#{attr}">#{value}</ph></p>) if not built_in.key? attr.downcase
end

# Compose the document footer:
result << %(  </conbody>)
result << %(</concept>)

# Print the document to standard output:
puts result
