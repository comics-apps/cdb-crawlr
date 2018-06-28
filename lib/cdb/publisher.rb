module CDB
  class Publisher < Struct.new(:cdb_id, :name, :series)
    WEB_PATH = 'publisher.php'

    def self.show(id, options = {})
      CDB.show(id, self, options)
    end

    def self.parse_data(id, page)
      publisher = new(
        :cdb_id => id.to_i,
        :name => page.css('.page_subheadline').first.text.strip
      )

      publisher.series = page.css("a[href^=\"#{CDB::Series::WEB_PATH}\"]").map do |link|
        CDB::Series.from_link(link, publisher)
      end

      publisher
    end
  end
end
