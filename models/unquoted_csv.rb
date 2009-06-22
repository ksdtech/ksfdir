require 'fastercsv'

def bool_convert(attrs, key)
  return if attrs[key].nil?
  test = attrs[key].to_s.downcase
  if ['true','t','1','yes','on'].include?(test)
    attrs[key] = true
  elsif ['false','f','0','no','off'].include?(test)
    attrs[key] = false
  end
end

def int_convert(attrs, key)
  # works with nil, too!
  attrs[key] = attrs[key].to_i
end

VALID_EMAIL = /^[-_\.\+a-z0-9]+\@[-_\.a-z0-9]+\.[a-z]+$/
def email_convert(attrs, key)
  email = (attrs[key] || '').strip.downcase
  if email.empty?
    email = nil
  elsif !email.match(VALID_EMAIL)
    puts "invalid #{key}: #{email}" 
    email = nil
  end
  attrs[key] = email
end

INVALID_NAME_CHARS = /[^-.'A-Za-z0-9]+/
def name_convert(attrs, key)
  name = (attrs[key] || '').gsub(INVALID_NAME_CHARS, ' ').strip
  attrs[key] = !name.empty? ? name : nil
end

def list_convert(attrs, key)
end

def state_convert(attrs, key)
  name = (attrs[key] || '')[0,2].strip
  attrs[key] = !name.empty? ? name : nil
end

class UnquotedCSV < FasterCSV
  # Pre-compiles parsers and stores them by name for access during reads.
  def init_parsers(options)
    # store the parser behaviors
    @skip_blanks = options.delete(:skip_blanks)
    
    # prebuild Regexps for faster parsing
    @parsers    = {
      :leading_fields =>
        /\A(?:#{Regexp.escape(@col_sep)})+/,     # for empty leading fields
      :csv_row        =>
        ### The Primary Parser ###
        / \G(?:^|#{Regexp.escape(@col_sep)})     # anchor the match
              ([^#{Regexp.escape(@col_sep)}]*)   # unquoted fields
              /x,
        ### End Primary Parser ###
      :line_end       =>
        /#{Regexp.escape(@row_sep)}\Z/           # safer than chomp!()
    }
  end
  
  # \G matches at the position where the previous match ended
  # (?:...) non-capturing parentheses group
  # ?> prevents backtracking
  # /x allow whitespace and comments in definition
  
  def self.open(*args)
    # find the +options+ Hash
    options = if args.last.is_a? Hash then args.pop else Hash.new end
    # wrap a File opened with the remaining +args+
    csv     = new(File.open(*args), options)
    
    # handle blocks like Ruby's open(), not like the CSV library
    if block_given?
      begin
        yield csv
      ensure
        csv.close
      end
    else
      csv
    end
  end
  
  def self.foreach(path, options = Hash.new, &block)
    open(path, options) do |csv|
      csv.each(&block)
    end
  end
  
  # 
  # The primary read method for wrapped Strings and IOs, a single row is pulled
  # from the data source, parsed and returned as an Array of fields (if header
  # rows are not used) or a FasterCSV::Row (when header rows are used).
  # 
  # The data source must be open for reading.
  # 
  def shift
    #########################################################################
    ### This method is purposefully kept a bit long as simple conditional ###
    ### checks are faster than numerous (expensive) method calls.         ###
    #########################################################################
    
    # handle headers not based on document content
    if header_row? and @return_headers and
       [Array, String].include? @use_headers.class
      if @unconverted_fields
        return add_unconverted_fields(parse_headers, Array.new)
      else
        return parse_headers
      end
    end
    
    # begin with a blank line, so we can always add to it
    line = ""

    # 
    # it can take multiple calls to <tt>@io.gets()</tt> to get a full line,
    # because of \r and/or \n characters embedded in quoted fields
    # 
    loop do
      # add another read to the line
      line  += @io.gets(@row_sep) rescue return nil
      # copy the line so we can chop it up in parsing
      parse = line.dup
      parse.sub!(@parsers[:line_end], "")
      
      # 
      # I believe a blank line should be an <tt>Array.new</tt>, not 
      # CSV's <tt>[nil]</tt>
      # 
      if parse.empty?
        @lineno += 1
        if @skip_blanks
          line = ""
          next
        elsif @unconverted_fields
          return add_unconverted_fields(Array.new, Array.new)
        elsif @use_headers
          return FasterCSV::Row.new(Array.new, Array.new)
        else
          return Array.new
        end
      end

      # 
      # shave leading empty fields if needed, because the main parser chokes 
      # on these
      # 
      csv = if parse.sub!(@parsers[:leading_fields], "")
        [nil] * ($&.length / @col_sep.length)
      else
        Array.new
      end
      # 
      # then parse the main fields with a hyper-tuned Regexp from 
      # Mastering Regular Expressions, Second Edition
      # 
      parse.gsub!(@parsers[:csv_row]) do
        csv << if $1.empty?        # switch empty unquoted fields to +nil+...
          nil               # for CSV compatibility
        else
          # I decided to take a strict approach to CSV parsing...
          if $1.count("\r\n").zero?  # verify correctness of field...
            $1
          else
            # or throw an Exception
            raise MalformedCSVError, "Unquoted fields do not allow " +
                                     "\\r or \\n (line #{lineno + 1})."
          end
        end
        ""  # gsub!'s replacement, clear the field
      end

      # if parse is empty?(), we found all the fields on the line...
      if parse.empty?
        @lineno += 1

        # save fields unconverted fields, if needed...
        unconverted = csv.dup if @unconverted_fields

        # convert fields, if needed...
        csv = convert_fields(csv) unless @use_headers or @converters.empty?
        # parse out header rows and handle FasterCSV::Row conversions...
        csv = parse_headers(csv)  if     @use_headers

        # inject unconverted fields and accessor, if requested...
        if @unconverted_fields and not csv.respond_to? :unconverted_fields
          add_unconverted_fields(csv, unconverted)
        end

        # return the results
        break csv
      end
      # if we're not empty?() but at eof?(), a quoted field wasn't closed...
      if @io.eof?
        raise MalformedCSVError, "Unclosed quoted field on line #{lineno + 1}."
      end
      # otherwise, we need to loop and pull some more data to complete the row
    end
  end  
end
