# frozen_string_literal: true

require 'active_record'
require 'dotenv'
require 'fileutils'
require 'httparty'
require 'uri'

Dotenv.load('./.env.development')

Dir.glob('./lib/**/*.rb').sort.each { |file| load file }
Dir.glob('./models/**/*.rb').sort.each { |file| load file }
