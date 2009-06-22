# phonenumber.rb

class PhoneNumber

  @@default_area_code = '415'

  attr_reader :area_code, :local_phone, :extension

  def initialize(phone, default_ac='')
    @is_us_phone = false
    @area_code = ''
    @local_phone = ''
    @extension = ''   
    if default_ac == ''
      default_ac = @@default_area_code
    end
    phone = phone.strip
    ph = phone.gsub(/[.,]/, '')
    extension = ''
    m = ph.match(/^[\(]?\s*([0-9]{3})\s*[\)]?\s*[-+\/]?\s*([0-9]{3})\s*[-+\/]?\s*([0-9]{4})([^0-9]?.*)$/)
    if !m.nil?
      @is_us_phone = true
      @area_code = m[1]
      @local_phone = "#{m[2]}-#{m[3]}"
      extension = m[4].strip
    else
      m = ph.match(/^([0-9]{3})\s*[-+\/]?\s*([0-9]{4})([^0-9]?.*)$/)
      if !m.nil?
        @is_us_phone = true
        @area_code = default_ac
        @local_phone = "#{m[1]}-#{m[2]}"
        extension = m[3].strip
      end
    end
    if extension != ''
      m = extension.downcase.match(/^(x|ex)[a-z]+[- ]*([0-9]+)/)
      if !m.nil?
        @extension = "x#{m[2]}"
      else
        @extension = extension
      end
    end
    if !@is_us_phone
      @local_phone = phone
    end
  end
  
  def is_us_phone?
    @is_us_phone
  end
    
  def to_s
    if @area_code != '' && @area_code != @@default_area_code
      return "(#{@area_code}) #{@local_phone} #{@extension}".strip
    end
    return "#{@local_phone} #{@extension}".strip
  end

end   
