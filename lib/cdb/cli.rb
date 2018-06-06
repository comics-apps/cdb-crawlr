require 'thor'

module CDB
  class CLI < Thor
    desc "search [TYPE] [QUERY]", "Search for entries of a given TYPE matching QUERY"
    long_desc <<-LONGDESC
      Search for entries of a given TYPE matching QUERY

      TYPE - "issue" or "series"
      \x5QUERY - query string

      Optional options:
      \x5--proxy "http://123.123.123.123:8888"
      \x5--user_agent "Mozilla/5.0 (Windows NT 6.3; WOW64; rv:34.0) Gecko/20100101 Firefox/34.0"
    LONGDESC
    method_option :proxy
    method_option :user_agent
    def search(type, query)
      case type
      when 'series'
        CDB::Series.search(query, options).each{|r| puts r.to_json}
      when 'issue', 'issues'
        CDB::Issue.search(query, options).each{|r| puts r.to_json}
      end
    end

    desc "show [TYPE] [CDB_ID]", "Show details of an entry using a CDB_ID obtained from search"
    long_desc <<-LONGDESC
      Show details of an entry using a CDB_ID obtained from search

      TYPE - "series"

      Optional options:
      \x5--proxy "http://123.123.123.123:8888"
      \x5--user_agent "Mozilla/5.0 (Windows NT 6.3; WOW64; rv:34.0) Gecko/20100101 Firefox/34.0"
    LONGDESC
    method_option :proxy
    method_option :user_agent
    def show(type, cdb_id)
      case type
      when 'series'
        res = CDB::Series.show(cdb_id, options)
        res.issues.each{|i| i.series=nil}
        puts res.to_json(array_nl:"\n", object_nl:"\n", indent:'  ')
      end
    end

    desc "rename", "Rename a directory of comics according to series data"
    long_desc <<-LONGDESC
      Rename a directory of comics according to series data

      Optional options:
      \x5-f / --force - Perform the rename without any confirmations
      \x5-i / --ignore - Ignore warnings about unknown and misformatted issue numbers
      \x5--proxy "http://123.123.123.123:8888"
      \x5--user_agent "Mozilla/5.0 (Windows NT 6.3; WOW64; rv:34.0) Gecko/20100101 Firefox/34.0"
    LONGDESC
    method_option :force, type: :boolean, aliases: "-f"
    method_option :ignore, type: :boolean, aliases: "-i"
    def rename
      renamer = CDB::Renamer.new(options)
      renamer.execute
    end
  end
end
