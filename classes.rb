class Quote
    attr_reader :author, :link, :count
    def initialize(author, link, count)
        @author = author
        @link = link
        @count = count
    end
end