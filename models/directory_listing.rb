# Directory listing routines

PVWKEY_HP = '0:0::'
PVWKEY_MH = '1:0:: (Mom)'
PVWKEY_MW = '2:0:(W) : (Mom)'
PVWKEY_MC = '3:0:(C) : (Mom)'
PVWKEY_MP = '4:0:(P) : (Mom)'
PVWKEY_FH = '1:1:: (Dad)'
PVWKEY_FW = '2:1:(W) : (Dad)'
PVWKEY_FC = '3:1:(C) : (Dad)'
PVWKEY_FP = '4:1:(P) : (Dad)'
PVWKEY_BH = '1:0:: (Both)'
PVWKEY_BW = '2:0:(W) : (Both)'
PVWKEY_BC = '3:0:(C) : (Both)'
PVWKEY_BP = '4:0:(P) : (Both)'
PVWKEY_ME1 = '1:0:: (Mom)'
PVWKEY_ME2 = '2:0:: (Mom)'
PVWKEY_FE1 = '1:1:: (Dad)'
PVWKEY_FE2 = '2:1:: (Dad)'
PVWKEY_BE1 = '1:0:: (Both)'
PVWKEY_BE2 = '1:0:: (Both)'

CITY_ABBRS = {
  'kentfield' => 'K.',
  'greenbrae' => 'G.',
  'larkspur'  => 'L.',
  'san rafael'   => 'S.R.',
  'san anselmo'  => 'S.A.',
  'corte madera' => 'C.M.',
  'sausalito'    => 'S.',
  'tiburon'      => 'T.',
  'mill valley'  => 'M.V.',
  'novato'    => 'N.',
  'belvedere' => 'Belv.',
  'woodacre'  => 'Wdcr.',
  'fairfax'   => 'Frfx.'  
}


def list_home?(record, hkey)
  return true
  # record["#{hkey}unl"] != 1
end

def list_address?(record, hkey)
  return true
  # list_home?(record, hkey)
end

def list_student?(record, hkey)
  return true
  # list_home?(record, hkey)
end

def list_parent?(record, hkey, pkey)
  return true
  # list_home?(record, hkey) && record["#{pkey}unl"] != 1
end

def list_phone?(record, hkey, pkey, ekey)
  return true
  # list_parent?(record, hkey, pkey) && record["#{pkey}#{ekey}unl"] != 1
end

def list_email?(record, hkey, pkey, ekey)
  return true
  # list_parent?(record, hkey, pkey) && record["#{pkey}#{ekey}unl"] != 1
end

def parent_last_name(record, pkey)
  case pkey
    when 'h1_p1_'
      record[:mother]
    when 'h1_p2_'
      record[:father]
    when 'h2_p1_'
      record[:mother2_last]
    when 'h2_p2_'
      record[:father2_last]
    else
      nil
  end
end

def parent_first_name(record, pkey)
  case pkey
    when 'h1_p1_'
      record[:mother_first]
    when 'h1_p2_'
      record[:father_first]
    when 'h2_p1_'
      record[:mother2_first]
    when 'h2_p2_'
      record[:father2_first]
    else
      nil
  end
end


class DirectoryListing

  attr_reader :cells, :see_also_refs
  
  @@default_options = {
    'show_all' => false,
    'show_home2' => false,
    'debug' => true,
  }
  
  def primary_home_id
    @homes['cust']['home_id']
  end

  def secondary_home_id
    @homes['nc']['home_id']
  end  
  
  def initialize(last_name, options={})
    @last_name = last_name
    @cells = [ ]
    @see_also_refs = { }
    @homes = { 
      'cust' => { 
        'home_id' => 0,
        'parent_names' => { },
        'address_am' => { },
        'address_ar' => { },
        'phone' => { }, 
        'email' => { },
        ' (Mom)' => ' (Mom)',
        ' (Dad)' => ' (Dad)',
        ' (Both)' => ''
        }, 
      'nc' => {
        'home_id' => 0,
        'parent_names' => { },
        'address_am' => { },
        'address_ar' => { },
        'phone' => { }, 
        'email' => { },
        ' (Mom)' => ' (Mom)',
        ' (Dad)' => ' (Dad)',
        ' (Both)' => ''
        }
      }
    @kids = { }
    options = @@default_options.merge(options)
    @show_home2 = options['show_home2']
    @show_all = options['show_all']
    @debug = options['debug']
    @debug_msgs = [ ]
  end

  def load_cells(key, i, can_format, home_id=0)
    can_edit = (home_id != 0 && @homes[key]['home_id'] == home_id)
    pre = ''
    post = ''
    if can_format && can_edit 
      pre = '<strong>'
      post = '</strong>'
    end

    highest_1 = i
    if !@homes[key]['parent_names'].nil_or_empty?
      @cells[highest_1+1] = pre + @homes[key]['parent_names'] + post
      highest_1 += 3
    end

    if !@homes[key]['address_ar'].nil_or_empty?
      @cells[highest_1+1] = pre + @homes[key]['address_ar'] + post
      highest_1 += 3
    end

    pcount = @homes[key]['parent_count']

    @homes[key]['email'].keys.sort.each do | whos |
      email = @homes[key]['email'][whos]
      who = whos.split(':', 4)
      loc = who[2] # (H), (W), etc.
      abbr = ''
      if pcount > 1
        abbr = @homes[key].fetch(who[3], who[3]) # (Mom), (Dad), (Both)
      end
      @cells[highest_1+1] = pre + loc + email + abbr + post
      highest_1 += 3
    end

    highest_2 = i
    last_row = -1
    phones = ''
    @homes[key]['phone'].keys.sort.each do | whos |
      phone = @homes[key]['phone'][whos]
      who = whos.split(':', 4)
      row = who[0]
      col = who[1]
      loc = who[2] # (C), (W), etc.
      abbr = ''
      if pcount > 1
        abbr = @homes[key].fetch(who[3], who[3]) # (Mom), (Dad), (Both)
      end
      if last_row != row
        if !phones.nil_or_empty? 
          j = highest_2 + 2
          @cells[j] = pre + phones + post
          highest_2 += 3
          phones = ''
        end
        last_row = row
      end
    
      if phones.nil_or_empty? 
        phone = loc + phone
      else 
        phones << ' / '
      end
      phones << phone + abbr
    end
    
    if !phones.nil_or_empty? 
      j = highest_2 + 2
      @cells[j] = pre + phones + post
      highest_2 += 3
      phones = ''
    end

    highest_0 = i
    if key == 'cust' 
      @cells[highest_0] = @last_name 
      highest_0 += 3  
      @kids.keys.sort.each do | key |
        kid = @kids[key] 
        @cells[highest_0] = pre + kid + post
        highest_0 += 3
      end
    end

    if highest_1 < highest_0
      highest_1 = highest_0
    end
    
    if highest_1 < highest_2
      highest_1 = highest_2
    end
    highest_1
  end

  def debug_html()
    s = String.new
    @homes.keys.each do | key |
      @homes[key].keys.each do | subkey |
        val = @homes[key][subkey]
        if val.kind_of?(Hash)
          val.keys.each do | sskey |
            s << "<tr><td colspan=\"3\">@homes[#{key}][#{subkey}][#{sskey}]: #{@homes[key][subkey][sskey]}</td></tr>"
          end
        else
          s << "<tr><td colspan=\"3\">@homes[#{key}][#{subkey}]: #{@homes[key][subkey]}</td></tr>"
        end
      end
    end
    s
  end

  def to_html_table_rows(home_id=0)
    s = ''
    if @debug
      @debug_msgs.each do | msg |
        s << "<tr><td colspan=\"3\">#{msg}</td></tr>\n"
      end
    end
    @cells.clear
    highest_cust = load_cells('cust', 0, true, home_id)
    highest = load_cells('nc', highest_cust, true, home_id)

    i = 0
    while i < highest
      s <<  "<tr>"
      s <<  "<td width=\"18%\" valign=\"top\" align=\"left\">#{@cells[i]}</td>"
      s <<  "<td width=\"36%\" valign=\"top\" align=\"left\">#{@cells[i+1]}</td>"
      s <<  "<td valign=\"top\" align=\"right\">#{@cells[i+2]}</td>"
      s <<  "</tr>\n"
      i += 3
    end
    
    @see_also_refs.each do | ref, last | 
      s <<  "<tr>"
      s <<  "<td valign=\"top\" align=\"left\" colspan=\"3\"#{ref} - See #{last}</td>"
      s <<  "</tr>\n"
    end
    s
  end
  
  def to_s
    @cells.clear
    highest_cust = load_cells('cust', 0, false)
    highest = load_cells('nc', highest_cust, false)
    
    s = ''
    #if @confirmed 
    # s << "Status of listing: confirmed\n\n"
    #else 
    # s << "Status of listing: unconfirmed\n\n"
    #end

    i = 0
    while i < highest
      s << sprintf('%-16s  ', @cells[i])
      s << sprintf('%-30s  ', @cells[i+1])
      s << "#{@cells[i+2]}\n"
      i += 3
    end
    
    @see_also_refs.each do | ref, last | 
      s << "#{ref} - See #{last}\n"
    end

    s
  end
  
  def add_names(record, key)  
    if @debug
      @debug_msgs.push("adding names for #{key}")
    end
    hkey = 'h1_'
    mkey = 'h1_p1_' 
    fkey = 'h1_p2_' 
    if key != 'cust'  
      if !@show_home2  
        if @debug
          @debug_msgs.push("show_home2 NOT")
        end
        return 
      end
      hkey = 'h2_'
      mkey = 'h2_p1_' 
      fkey = 'h2_p2_' 
    end

    [ [ 'ml', 'mf', mkey ], [ 'fl', 'ff', fkey ] ].each do | tuple |
      pkey = tuple[2]
      if list_parent?(record, hkey, pkey) && @homes[key][tuple[0]].nil_or_empty?
        last = parent_last_name(record, pkey)
        first = parent_first_name(record, pkey)
        if !first.nil_or_empty? && !last.nil_or_empty?
          @homes[key][tuple[0]] = last 
          @homes[key][tuple[1]] = first
        end
      end
    end
    
    if !@homes[key]['mf'].nil_or_empty? && !@homes[key]['ff'].nil_or_empty?
      mom = @homes[key]['mf'][0,1].upcase + '.'
      dad = @homes[key]['ff'][0,1].upcase + '.'
      if mom == dad
        mom = @homes[key]['mf']
        dad = @homes[key]['ff']
      end
      @homes[key][' (Mom)'] = " (#{mom})"
      @homes[key][' (Dad)'] = " (#{dad})"
    end
  end
  
  def address_prefix(hkey, atype)
    hkey != 'h2_' ? (atype == 'ar' ? '' : 'mailing_' ) : (atype == 'ar' ? 'home2_' : 'mailing2_')
  end

  def add_addresses(record, key)
    hkey = 'h1_'
    if key != 'cust'  
      if !@show_home2
        return 
      end
      key = 'nc'
      hkey = 'h2_' 
    end
    
    if list_address?(record, hkey)
      akeys = [ 'ar', 'am' ]
      akeys.each do | atype |
        addr_prefix = address_prefix(hkey, atype)
        addr = @homes[key]["address_#{atype}"]
        if addr.nil_or_empty?
          street = record["#{addr_prefix}street".to_sym] 
          city   = record["#{addr_prefix}city".to_sym] 
          state  = record["#{addr_prefix}state".to_sym] 
          zip    = record["#{addr_prefix}zip".to_sym]
          if !street.nil_or_empty? && !city.nil_or_empty? && !zip.nil_or_empty? 
            street = StreetAddress.new(street).to_s
            city = CITY_ABBRS.fetch(city.downcase, city) 
            if !state.nil_or_empty? && state != 'CA'
              @homes[key]["address_#{atype}"] = "#{street}, #{city}, #{state} #{zip}" 
            else
              @homes[key]["address_#{atype}"] = "#{street}, #{city} #{zip}" 
            end
          end
        end
      end
    end
  end

  def add_phones(record, key)
    hkey = 'h1_' 
    hp = :home_phone
    mkey = 'h1_p1_' 
    mpre = 'mother_'
    fkey = 'h1_p2_'
    fpre = 'father_'
    if key != 'cust' 
      if !@show_home2  
        return 
      end   
      key = 'nc' 
      hkey = 'h2_' 
      hp = :home2_phone
      mkey = 'h2_p1_' 
      mpre = 'mother2_'
      fkey = 'h2_p2_' 
      fpre = 'father2_'
    end
    
    [ 
      [ PVWKEY_HP, list_phone?(record, hkey, hkey, 'ph_home_'), hp],
      [ PVWKEY_MH, list_phone?(record, hkey, mkey, 'ph_home_'), "#{mpre}home_phone".to_sym],
      [ PVWKEY_MW, list_phone?(record, hkey, mkey, 'ph_work_'), "#{mpre}work_phone".to_sym],
      [ PVWKEY_MC, list_phone?(record, hkey, mkey, 'ph_mobile_'), "#{mpre}cell".to_sym],
      # [ PVWKEY_MP, list_phone?(record, hkey, mkey, 'ph_pager_'), "#{mpre}pager".to_sym],
      [ PVWKEY_FH, list_phone?(record, hkey, fkey, 'ph_home_'), "#{fpre}home_phone".to_sym],
      [ PVWKEY_FW, list_phone?(record, hkey, fkey, 'ph_work_'), "#{fpre}work_phone".to_sym],
      [ PVWKEY_FC, list_phone?(record, hkey, fkey, 'ph_mobile_'), "#{fpre}cell".to_sym],
      # [ PVWKEY_FP, list_phone?(record, hkey, fkey, 'ph_pager_'), "#{fpre}pager".to_sym],
    ].each do | tuple |
      tel =  @homes[key]['phone'][tuple[0]] 
      if tel.nil_or_empty? && !record[tuple[2]].nil_or_empty? && (@show_all || tuple[1])  
        @homes[key]['phone'][tuple[0]] = PhoneNumber.new(record[tuple[2]]).to_s
      end
    end
  end
  
  def add_emails(record, key)  
    hkey = 'h1_' 
    mother_prefix = 'mother_' 
    father_prefix = 'father_'
    mkey = 'h1_p1_'
    fkey = 'h1_p2_'
    if key != 'cust' 
      if !@show_home2  
        return 
      end   
      key = 'nc' 
      hkey = 'h2_' 
      mother_prefix = 'mother2_' 
      father_prefix = 'father2_' 
      mkey = 'h2_p1_'
      fkey = 'h2_p2_'
    end

    [ 
      [ PVWKEY_ME1, list_email?(record, hkey, mkey, 'em1_'), "#{mother_prefix}email".to_sym],
      # [ PVWKEY_ME2, list_email?(record, hkey, mkey, 'em2_'), "#{mother_prefix}email2"],
      [ PVWKEY_FE2, list_email?(record, hkey, fkey, 'em1_'), "#{father_prefix}email".to_sym],
      # [ PVWKEY_FE2, list_email?(record, hkey, fkey, 'em2_'), "#{father_prefix}email2"],
    ].each do | tuple |
      email = @homes[key]['email'][tuple[0]]
      new_email = record[tuple[2]] 
      if email.nil_or_empty? && !new_email.nil_or_empty? && (@show_all || tuple[1])
        @homes[key]['email'][tuple[0]] = new_email
      end
    end
  end

  def add_student(record, key)  
    first_name = !record[:nickname].nil_or_empty? ? record[:nickname] : record[:first_name]

    home_id = record[:home_id]
    if key != 'cust' 
      if !@show_home2  
        return 
      end   
      key = 'nc' 
      home_id = record[:home2_id]
    end
    home_id = 0 if home_id.nil?

    if @homes[key]['home_id'] == 0
      @homes[key]['home_id'] = home_id
    end

    grade = record[:grade_level]
    sort_grade = sprintf('%02d', 9 - grade) 
    if grade == 0
      grade = 'K'
    end
    key = "#{sort_grade}#{first_name.upcase}"
    @kids[key] = "#{first_name} (#{grade})" 
  end

  def add_record(record)  
    @debug_msgs.push("add_record: sh2:#{@show_home2}, h1:#{record[:home_id]}, h2:#{record[:home2_id]}")
    [ 'cust', 'nc' ].each do | key | 
      if key == 'cust' || (@show_home2 && record[:home2_id] != 0) 
        add_names(record, key) 
        add_addresses(record, key) 
        add_phones(record, key) 
        add_emails(record, key)
        add_student(record, key) 
      end
    end 
  end
  
  def finalize_names(key)
    if key != 'cust'  
      if @homes['nc']['home_id'] == 0 || !@show_home2  
        return 
      end
      key = 'nc' 
    end

    # parent name information
    mfirst =  @homes[key]['mf'] 
    mlast  =  @homes[key]['ml'] 
    ffirst =  @homes[key]['ff'] 
    flast  =  @homes[key]['fl'] 
    pcount = 0
    if !mlast.nil_or_empty? && !flast.nil_or_empty?
      pcount = 2
      if mlast == flast
        @homes[key]['parent_names'] = "#{mfirst} & #{ffirst} #{flast}" 
      else  
        @homes[key]['parent_names'] = "#{mfirst} #{mlast} & #{ffirst} #{flast}" 
      end
    elsif !mlast.nil_or_empty?
      pcount = 1
      @homes[key]['parent_names'] = "#{mfirst} #{mlast}" 
    elsif !flast.nil_or_empty? 
      pcount = 1
      @homes[key]['parent_names'] = "#{ffirst} #{flast}" 
    elsif @debug   
      @homes[key]['parent_names'] = '(NO NAMES)' 
    end
    @homes[key]['parent_count'] = pcount 
    
    # use mailing address if no residential address given
    if @homes[key]['address_ar'].nil_or_empty? && !@homes[key]['address_am'].nil_or_empty?
      @homes[key]['address_ar'] = @homes[key]['address_am'] 
    end     
    if @debug && @homes[key]['address_ar'].nil_or_empty?
      @homes[key]['address_ar'] = '(NO ADDRESS)' 
    end

    # see also listings
    [ [ mlast, mfirst ], [ flast, ffirst ] ].each do | names |
      if !names[0].nil_or_empty?
        see_also_ref = names[0].upcase
        if see_also_ref != @last_name.upcase  
          if !names[1].nil_or_empty?  
            see_also_ref << ", #{names[1]}"
            @see_also_refs[see_also_ref] = @last_name 
          end
        end
      end
    end

    # remove duplicate phone numbers
    home_phone = @homes[key]['phone'][PVWKEY_HP] 
    mcell = @homes[key]['phone'][PVWKEY_MC] 
    fcell = @homes[key]['phone'][PVWKEY_FC] 
    [ 
      PVWKEY_MH, PVWKEY_MW, PVWKEY_MC, PVWKEY_MP,
      PVWKEY_FH, PVWKEY_FW, PVWKEY_FC, PVWKEY_FP, 
    ].each do | phkey |
      phone = @homes[key]['phone'][phkey] 
      if !phone.nil_or_empty? && phone == home_phone
        @homes[key]['phone'].delete(phkey)
      end
      if phkey != PVWKEY_MC && phkey != PVWKEY_FC && !phone.nil_or_empty? && (phone == mcell || phone == fcell)
        @homes[key]['phone'].delete(phkey)
      end
    end

    # convert same phones to "Both"
    [ 
      [ PVWKEY_MH, PVWKEY_FH, PVWKEY_BH ], 
      [ PVWKEY_MW, PVWKEY_FW, PVWKEY_BW ], 
      [ PVWKEY_MC, PVWKEY_FC, PVWKEY_BC ], 
      [ PVWKEY_MP, PVWKEY_FP, PVWKEY_BP ], 
    ].each do | tuple |
      phone = @homes[key]['phone'][tuple[0]] 
      if !phone.nil_or_empty? && phone == @homes[key]['phone'][tuple[1]]
        @homes[key]['phone'][tuple[2]] = phone
        @homes[key]['phone'].delete(tuple[0])
        @homes[key]['phone'].delete(tuple[1])
      end
    end   
    
    # convert same emails to "Both"
    emails = Hash.new
    bothcount = 0
    [ PVWKEY_ME1, PVWKEY_ME2, PVWKEY_FE1, PVWKEY_FE2 ].each do | ekey |
      email = @homes[key]['email'][ekey]
      if !email.nil? && emails.has_key?(email)
        old_key = emails[email]
        if old_key.include?('Mom') && ekey.include?('Dad')
          new_key = bothcount == 0 ? PVWKEY_BE1 : PVWKEY_BE2
          @homes[key]['email'].delete(old_key)
          @homes[key]['email'][new_key] = email
          emails[email] = new_key
          bothcount += 1
        end
        @homes[key]['email'].delete(ekey)
      else
        emails[email] = ekey
      end
    end
  end 
  
  def prepare_for_output()  
    finalize_names('cust')
    finalize_names('nc')
  end

end

class DirectoryItem
  attr_accessor :primary_home_id, :secondary_home_id, :cells, :highest
  
  def initialize(h1, h2, cells, highest)
    @primary_home_id = h1
    @secondary_home_id = h2
    @cells = cells.dup
    @highest = highest
  end
  
  def is_see_also?
    @highest < 0
  end
end


class Directory
  attr_accessor :items, :families
  
  def initialize(home_ids, debug)
    @home_ids = home_ids || Student.all_home_ids
    @debug = debug
    # debugging, just pick 20
    @home_ids = @home_ids.slice(0, 20) if @debug
    @show_all_homes = false
    @items = { }
    @families = { }
    @debug_msgs = [ ]
  end
  
  def add_one_family(base_home_id)
    begin_count = @items.size
    @families[base_home_id] ||= [ ]
    related_families = get_families(base_home_id)
    related_families.each do | name, family |
      family.prepare_for_output
      highest = family.load_cells('cust', 0, false)
      highest = family.load_cells('nc', highest, false)
      oldest_sib_first_name = family.cells[3]
      di = DirectoryItem.new(family.primary_home_id,
        family.secondary_home_id, family.cells, highest)
      @items["#{name}:d:#{oldest_sib_first_name}"] = di
      @families[base_home_id].push(di)
      family.see_also_refs.each do | ref, last |
        seealso = ref.split(',', 2)[0].upcase
        di = DirectoryItem.new(0, 0, { ref => last }, -1)
        @items["#{seealso}:s:#{ref}#{last}"] = di
      end 
    end
    puts "#{base_home_id} added #{@items.size - begin_count}" if @debug
  end
  
  # whole phone book
  def add_preview_data()
    @show_all_homes = true
    @home_ids.each do |base_home_id| 
      add_one_family(base_home_id)
    end
  end

  # single family only
  def to_html
    s = ''
    families = get_families(@home_ids[0])
    if @debug
      s << "<p>Debugging:<br/>" + @debug_msgs.join("<br/>") + "</p>"
    end
    s << %{<table border="0" width="100%">}
    families.keys.sort.each do | name |
      family = families[name]
      family.prepare_for_output
      s << family.to_html_table_rows
    end
    s << "</table>"
    s
  end

  # single family only
  def to_s
    s = ''
    families = get_families(@home_ids[0])
    families.keys.sort.each do | name |
      family = families[name]
      family.prepare_for_output
      s << family.to_s
      s << "\n"
    end
    s
  end

  def get_all_related_students(base_home_id)
    students = { }
    new_students = Directory.add_students_with_home_id(base_home_id, students) 
    sanity = 200
    while sanity > 0 && !new_students.nil?
      next_students = { }
      new_students.each do | key, record |
        home_id = record[:home_id] 
        next1_students = Directory.add_students_with_home_id(home_id, students)
        if !next1_students.nil? 
          next_students.merge!(next1_students)
          students.merge!(next1_students) 
        end
        home_id = record[:home2_id] 
        next1_students = Directory.add_students_with_home_id(home_id, students)
        if !next1_students.nil? 
          next_students.merge!(next1_students)
          students.merge!(next1_students) 
        end
      end
      new_students = next_students
      sanity -= 1
    end 
    students 
  end
  
  def get_families(base_home_id)
    families =  { }
    students = get_all_related_students(base_home_id)
    # puts "#{base_home_id} has #{students.size} related students"

    # figure out whether to show secondary parents for a given last name
    last_name_h2 = { }
    prev_last_name = ''
    students.keys.sort.each do | key |
      last_name = key.split(':', 2)[0]
      student = students[key]
      show_home2 = @show_all_homes || (student.home2_id == base_home_id)
      if show_home2 || !last_name_h2.has_key?(last_name)
        last_name_h2[last_name] = show_home2
      end
    end
    
    # create a listing for each last name
    students.keys.sort.each do | key |
      last_name = key.split(':', 2)[0]
      show_home2 = last_name_h2[last_name]
      student = students[key]
      if last_name != prev_last_name
        families[last_name] = DirectoryListing.new(last_name, 
          'debug' => @debug, 'show_home2' => show_home2)
        prev_last_name = last_name
      end
      families[last_name].add_record(student)
    end
    families
  end

  class << self
    def output_merge(f, home_ids=nil, debug=false)
      d = Directory.new(home_ids, debug)
      d.add_preview_data
      
      d.families.keys.sort.each do |home_id|
        fam = nil
        fam = Family.get(home_id)
        ln = fam.nil? ? nil : fam.last_name
        addr = fam.nil? ? nil : fam.mailing_address_fields
        addr = [ '', '', '', '' ] if addr.nil?
        items = d.families[home_id]
        item_count = 0
        items.each do |item|
          if !item.is_see_also?
            f.write "|#{home_id}\n"
            f.write "<#{ln}\n"
            f.write "<#{addr[0]}\n"
            f.write "<#{addr[1]}\n"
            f.write "<#{addr[2]}\n"
            f.write "<#{addr[3]}\n<"
            i = 0
            while i < item.highest
              f.write "#{item.cells[i]}\t"
              f.write "#{item.cells[i+1]}\t"
              f.write "#{item.cells[i+2]}\n"
              i += 3
            end
            f.write "NO INFORMATION\n" if i == 0
            item_count += 1
          end
        end
        if item_count == 0
          f.write "|#{home_id}\n"
          f.write "<#{ln}\n"
          f.write "<#{addr[0]}\n"
          f.write "<#{addr[1]}\n"
          f.write "<#{addr[2]}\n"
          f.write "<#{addr[3]}\n"
          f.write "<#{addr[4]}\n<"
          f.write "NO INFORMATION\n"
        end
      end
      f.close
    end
    
    def output_text(f, home_ids=nil, debug=false, family_sep="\f---\n", see_also_sep="\n---\n")
      d = Directory.new(home_ids, debug)
      d.add_preview_data
      
      d.items.keys.sort.each do |key|
        item = d.items[key]
        if !item.is_see_also? 
          next if item.highest <= 0
          f.write(family_sep)
          i = 0
          while i < item.highest
            f.write "#{item.cells[i]}\t"
            f.write "#{item.cells[i+1]}\t"
            f.write "#{item.cells[i+2]}\n"
            i += 3
          end
        else
          f.write(see_also_sep)
          item.cells.each do | ref, last | 
            f.write "#{ref} - See #{last}\n"
          end
        end
      end
      f.close
    end
    
    def add_students_with_home_id(home_id, other_students)
      if home_id.nil_or_zero?
        return nil
      end
      cond = "home_id=#{home_id} OR home2_id=#{home_id}"
      if other_students.size > 0
        other_ids = other_students.values.collect { | record | record[:student_number] }
        cond = "student_number NOT IN (#{other_ids.join(',')}) AND (#{cond})"
      end
      students = Student.all(:conditions => [cond])
      # puts "#{cond} returns #{students.size} students"
      if students.nil? || students.size == 0
        return nil
      end
    
      new_students = { }
      students.each do |stu|
        hkey = (stu.home2_id == home_id) ? 'h2_' : 'h1_'
        if @debug || list_student?(stu, hkey)
          lname = stu.last_name
          fname = stu.nickname || stu.first_name
          student_number = stu.student_number
          key = "#{lname}:#{fname}:#{student_number}".upcase 
          new_students[key] = stu.attributes
        end
      end
      new_students
    end
  end
end
