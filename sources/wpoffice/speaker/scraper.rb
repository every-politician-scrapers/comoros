#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class OfficeholderList < OfficeholderListBase
  decorator RemoveReferences
  decorator UnspanAllTables
  decorator WikidataIdsDecorator::Links

  def header_column
    'Notes'
  end

  class Officeholder < OfficeholderBase
    def columns
      %w[name start end].freeze
    end

    def non_data_row?
      tds[1].text.include?('?') || super
    end

    def vacant?
      tds[0].text.include?('abeyance') || super
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: OfficeholderList).csv
