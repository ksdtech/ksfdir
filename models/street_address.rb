# streetaddress.rb

def trim_with_abbr(s)
  s.gsub!(/^[. \t]+/, '')
  s.gsub!(/[. \t]+$/, '')
  return s
end
      
def fix_all_caps(words)
  fixed = []
  words.each do |wd|
    m = wd.match(/^\s*([A-Z])([A-Z0-9]+)\s*$/)
    if m.nil?
      fixed.push(wd)
    else
      fixed.push(m[1] + m[2].downcase)
    end
  end
  return fixed
end

def abbreviate(word, abbrs)
  return abbrs.fetch(word, word)
end

def trim_punctuation(word)
  word.gsub!(/^[ ,.]+/, '')
  word.gsub!(/'[ ,.]+$/, '')
  return word
end

def next_non_empty(words, i, find=nil)
  word_count = words.length
  i += 1
  while i < word_count
    w = trim_punctuation(words[i])
    if w != '' && (find.nil? || find.match(w))
      return i
    end
    i += 1
  end
  return -1
end

def next_non_empty_not(words, i, find)
  word_count = words.length
  i += 1
  while i < word_count
    w = trim_punctuation(words[i])
    if w != '' && !find.match(w)
      return i
    end
    i += 1
  end
  return -1
end

def prev_non_empty(words, i, find=nil)
  i -= 1
  while i >= 0
    w = trim_punctuation(words[i])
    if w != '' && (find.nil? || find.match(w))
      return i
    end
    i -= 1
  end
  return -1
end

def join_array(array, offset, length)
  s = ''
  for i in (offset...offset+length)
    w = trim_with_abbr(array[i])
    if w != ''
      if s != ''
        s += ' '
      end
      s += w
    end
  end
  return s
end

def hash_to_pattern(abbrs)
  pat = ''
  abbrs.each_key do |word|
    if pat != ''
      pat += '|'
    end
    pat += word
  end
  return Regexp.new("^(#{pat})$")
end

def py_split(s, pat)
  l = [ ]
  s1 = s
  m = pat.match(s1)
  while !m.nil?
    if !m.pre_match.empty?
      l.push(m.pre_match)
    end
    l.push(m[0])
    s1 = m.post_match
    m = pat.match(s1)
  end
  if !s1.empty?
    l.push(s1)
  end
  l
end

class StreetAddress
  include Comparable
  
  ADDRESS_KEYS = [
    'sBoxAbbr', 'sBoxNum',
    'sHouseNum', 'sPreDir', 'szStreetName', 'sStreetSuffix', 'sPostDir',
    'sUnitAbbr', 'sUnitNum',
    'szCity', 'szState', 'szZip' ] 
  
  DIR_ABBRS = {
    'S' => 'S.',
    'So' => 'S.',
    'South' => 'S.',
    'N' => 'N.',
    'No' => 'N.',
    'Nor' => 'N.',
    'North' => 'N.',
    'E' => 'E.',
    'East' => 'E.',
    'W' => 'W.',
    'West' => 'W.',
    'Ne' => 'NE',
    'Nw' => 'NW',
    'Se' => 'SE',
    'Sw' => 'SW',
    }
  
  # see http=>#www.usps.com/ncsc/lookups/abbrev.html
  STREET_ABBRS = {
    'Avenue' => 'Ave.', 
    'Ave' => 'Ave.', 
    'Av' => 'Ave.', 
    'Boulevard' => 'Blvd.', 
    'Boul' => 'Blvd.', 
    'Bl' => 'Blvd.', 
    'Blvd' => 'Blvd.', 
    'Circle' => 'Cir.', 
    'Cir' => 'Cir.', 
    'Court' => 'Ct.',
    'Ct' => 'Ct.',
    'Drive' => 'Dr.',  
    'Dr' => 'Dr.',
    'Drv' => 'Dr.',
    'Lane' => 'Ln.', 
    'Ln' => 'Ln.', 
    'Parkway' => 'Pkwy.',
    'Pkwy' => 'Pkwy.',
    'Place' => 'Pl.', 
    'Pl' => 'Pl.', 
    'Road' => 'Rd.', 
    'Rd' => 'Rd.', 
    'Street' => 'St.', 
    'St' => 'St.', 
    'Terrace' => 'Terr.',
    'Terr' => 'Terr.',
    'Way' => 'Way', 
    'Wy' => 'Way',
    }
  
  UNIT_ABBRS = {
    '#' => '#',
    'Apt' => '#', 
    'Apartment' => '#',
    'No' => '#',
    'Number' => '#', 
    'Ste' => 'Ste.', 
    'Suite' => 'Ste.', 
    'Unit' => 'Unit', 
    'Lower' => 'Lower',
    'Lowr' => 'Lower', 
    'Upper' => 'Upper',
    'Upr' => 'Upper', 
    }
    
  @@dir_pat = nil
  @@street_suff_pat = nil
  @@unit_pat = nil

  def <=>(other_address)
    if @full_address && (@szCity == '' || @szState == '' || @szZip == '')
      return -1
    end
    if zip != '' && other_address.zip != ''
      test = zip <=> other_address.zip
      if test != 0
        return test
      end
    end
    return street_ordered <=> other_address.street_ordered
  end
  
  def is_valid?
    if @full_address && (@szCity == '' || @szState == '' || @szZip == '')
      return false
    end
    
    ADDRESS_KEYS.each do |key|
      iv_symbol = "@#{key}".intern
      if instance_variable_get(iv_symbol).match(/\|/)
        return false
      end
    end
    
    return true
  end
  
  def street_ordered
    s = [@sPreDir, @szStreetName, @sStreetSuffix, @sPostDir, 
      ">#{@sHouseNum}", "##{@sUnitNum}", "<#{@sBoxNum}" ].join ' '
    return s.gsub(/\s+/, ' ').strip
  end
    
  def street
    s = [@sBoxAbbr, @sBoxNum,
      @sHouseNum, @sPreDir, @szStreetName, @sStreetSuffix, @sPostDir,
      @sUnitAbbr, @sUnitNum].join ' '
    return s.gsub(/\s+/, ' ').strip
  end
  
  def city
    @szCity
  end

  def state
    @szState
  end
  
  def zip
    @szZip
  end
  
  def to_s
    if !@full_address
      return street
    end
    return "#{street}, #{city}, #{state} #{zip}"
  end

  private 
  
  def initialize_ivars
    ADDRESS_KEYS.each do |key|
      iv_symbol = "@#{key}".intern
      instance_variable_set(iv_symbol, '')
    end
  end


  def initialize(address, city='', state='', zip='')
    @full_address = false
    initialize_ivars
    
    full = !address.index('|').nil? && city == '' && state == '' && zip == ''
  
    m = Regexp.new('^(P\.?\s*(O|M)\.?\s*B[.ox]*)\s+(\S+)', Regexp::IGNORECASE).match(address)
    if !m.nil?
      @sBoxAbbr = 'P.O. Box'
      @sBoxNum = m[3]
    else
      m = Regexp.new('^(Box|Bx)\s+(\S+)', Regexp::IGNORECASE).match(address)
      if !m.nil?
        @sBoxAbbr = 'P.O. Box'
        @sBoxNum = m[2]
      end
    end
    if !m.nil?
      address = m.post_match
    end
    
    address_parts = py_split(address, /[^-'A-Za-z0-9]/)
    address_parts = fix_all_caps(address_parts)
    n = address_parts.length
  
    i_box_end = -1
    i_box_num = -1
    i_house_num = 0
    i_house_num_end = -1
    i_pre_dir = -1
    i_street_prev = -1
    i_street_start = -1
    i_street_end = -1
    i_street_suffix = -1
    i_city_break = -1
    i_street_break = -1
    i_post_dir = -1
    i_unit_abbr = -1
    i_unit_num = -1
    i_unit_num_end = -1
    i_city_start = -1
    i_city_end = -1
    i_state = -1
    i_zip = -1
    
    if @@street_suff_pat.nil?
      @@street_suff_pat = hash_to_pattern(STREET_ABBRS)
    end
    if @@unit_pat.nil?
      @@unit_pat = hash_to_pattern(UNIT_ABBRS)
    end
    if @@dir_pat.nil?
      @@dir_pat = hash_to_pattern(DIR_ABBRS)
    end
      
    if full
      i_zip = prev_non_empty(address_parts, n, /^[0-9]{5,5}(-[0-9]{4,4})?$/)
      i_state = prev_non_empty(address_parts, i_zip, /^[A-Za-z]{2,2}$/)
      i_city_end = prev_non_empty(address_parts, i_state, /[A-Za-z]/)
      i_city_break = prev_non_empty(address_parts, i_city_end, /\|/)
      i_city_start = next_non_empty(address_parts, i_city_break)
    else
      i_city_break = n
    end
  
    i_street_break = i_city_break
    i_unit_num_end = i_city_break
      
    # house numbers like 1 1/2 ok
    # still a problem
    # 81-D Corte Lenora
    # 8638 15th Avenue
    # ok for single letters, except for NEWS
    i_house_num_end = next_non_empty_not(address_parts, i_house_num, 
      /^([-\/0-9]+)$/)
    could_be_house_num = address_parts[i_house_num_end]
    if !could_be_house_num.nil? && !could_be_house_num.match(/^[A-Za-z]$/)
      could_be_house_num = nil
    end
    
    i_street_start = i_house_num_end
    i_unit_abbr = prev_non_empty(address_parts, i_city_break, @@unit_pat)
    
    # problem with "Lower Via Casitas"
    if i_unit_abbr <= i_street_start
      i_unit_abbr = -1
    end
    if i_unit_abbr >= 0
      i_street_break = i_unit_abbr
      i_unit_num = next_non_empty(address_parts, i_unit_abbr)
      
      # unit numbers like A, 24, 25-C ok
      while i_unit_num > i_unit_abbr && i_unit_num < i_unit_num_end && 
        !address_parts[i_unit_num].match(/^[-0-9A-Za-z]+$/)
        i_unit_num = next_non_empty(address_parts, i_unit_num)
      end
      
      if i_unit_num == i_unit_num_end || i_unit_num >= i_city_break
        i_unit_num = -1
        i_unit_num_end = -1
      end
    end
    
    i_street_prev = prev_non_empty(address_parts, i_street_break)
    i_post_dir = prev_non_empty(address_parts, i_street_break, @@dir_pat)
    if i_post_dir == i_street_prev && i_post_dir > i_street_start && 
      i_post_dir != i_pre_dir
      i_street_break = i_post_dir
    else
      i_post_dir = -1
    end
  
    i_street_prev = prev_non_empty(address_parts, i_street_break)
    i_street_suffix = prev_non_empty(address_parts, i_street_break, @@street_suff_pat)
    if i_street_suffix == i_street_prev && i_street_suffix > i_street_start
      i_street_break = i_street_suffix
    else
      i_street_suffix = -1
    end
    
    # deal with single letter streets
    i_street_end = prev_non_empty(address_parts, i_street_break)
    
    if i_street_start < i_street_end
      if !could_be_house_num.nil?
        if could_be_house_num.match(@@dir_pat)
          i_pre_dir = i_house_num_end
          i_street_start = next_non_empty(address_parts, i_pre_dir)
        else
          i_house_num_end = next_non_empty(address_parts, i_house_num_end)
          i_street_start = i_house_num_end
        end
      end
      if i_street_start < i_street_end && i_pre_dir < 0 && 
        address_parts[i_street_start].match(@@dir_pat)
        i_pre_dir = i_street_start
        i_street_start = next_non_empty(address_parts, i_street_start)
      end
    end
    
    if i_house_num >= 0
      @sHouseNum = join_array(address_parts, i_house_num,
        i_house_num_end - i_house_num)
    end
    if i_pre_dir >= 0
      @sPreDir = abbreviate(address_parts[i_pre_dir], DIR_ABBRS)
    end
    if i_street_start >= 0 && i_street_start <= i_street_end
      street_name = join_array(address_parts, i_street_start,
        i_street_end - i_street_start + 1)
      @szStreetName = street_name
    end
    if i_street_suffix >= 0
      @sStreetSuffix = abbreviate(address_parts[i_street_suffix], STREET_ABBRS)
    end
    if i_post_dir >= 0
      @sPostDir = abbreviate(address_parts[i_post_dir], DIR_ABBRS)
    end
    if i_unit_abbr >= 0
      @sUnitAbbr = abbreviate(address_parts[i_unit_abbr], UNIT_ABBRS)
    end
    if i_unit_num >= 0 && i_unit_num < i_unit_num_end
      @sUnitNum =  join_array(address_parts, i_unit_num,
        i_unit_num_end - i_unit_num)
    end
    if full
      if i_city_start >= 0 && i_city_start <= i_city_end
        @fullAddress = true
        @szCity = join_array(address_parts, i_city_start,
          i_city_end - i_city_start + 1)
      end
      if i_state >= 0
        @fullAddress = true
        @szState = address_parts[i_state].upcase
      end
      if i_zip >= 0
        @fullAddress = true
        @szZip = address_parts[i_zip]
      end
    else
      @fullAddress = true
      @szCity = city.strip
      @szState = state.strip.upcase
      @szZip = zip.strip
    end
  end

end
