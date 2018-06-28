require 'json'
require 'nokogiri'
require 'open-uri'

$:.unshift(File.dirname(__FILE__))

require 'cdb/cli'
require 'cdb/renamer'
require 'cdb/struct'
require 'cdb/issue'
require 'cdb/publisher'
require 'cdb/series'
require 'cdb/version'

module CDB
  BASE_URL = 'http://www.comicbookdb.com'
  REQUEST_HEADERS = {'Connection' => 'keep-alive'}
  SEARCH_PATH = 'search.php'

  def self.search(query, type='FullSite', options = {})
    data = URI.encode_www_form(
      form_searchtype: type,
      form_search: query
    )
    url = "#{BASE_URL}/#{SEARCH_PATH}?#{data}"
    doc = read_page(url, options)
    node = doc.css('h2:contains("Search Results")').first.parent
    {
      :series => CDB::Series.parse_results(node),
      :issues => CDB::Issue.parse_results(node)
    }
  end

  def self.show(id, type, options = {})
    data = URI.encode_www_form('ID' => id)
    url = "#{BASE_URL}/#{type::WEB_PATH}?#{data}"
    page = read_page(url, options)
    type.parse_data(id, page)
  end

  def self.read_page(url, options)
    content = open(url, http_headers(options)).read
    content.force_encoding('ISO-8859-1').encode!('UTF-8')
    Nokogiri::HTML(content)
  end

  def self.http_headers(options)
    REQUEST_HEADERS.tap do |h|
      h['User-Agent'] = options[:user_agent] if options[:user_agent]
      h[:proxy] = options[:proxy] if options[:proxy]
    end
  end
end
