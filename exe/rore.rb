#!/usr/bin/env ruby

require_relative "../lib/rore"
require File.expand_path(File.join("config", "environment"))

Rore::CLI.run(ARGV)
