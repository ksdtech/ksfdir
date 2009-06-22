# nil_utils.rb

class Object
  def nil_or_empty?
    if self.nil? || self.to_s.empty?
      return true
    end
    false   
  end

  def nil_or_zero?
    if self.nil? || self.to_i == 0
      return true
    end
    false   
  end

  def nil_string
    if nil_or_empty?
      return '<nil>'
    end
    self.to_s
  end
end

def check_unique(h, key, value, msg_header='check_unique', errors=nil)
  if !key.nil_or_empty? && !value.nil_or_empty?
    if !h.has_key?(key)
      h[key] = value
    else
      existing_value = h[key]
      if existing_value != value
        msg = "#{msg_header}: key #{key} had value #{existing_value}, checking with value #{value}"
        if !errors.nil?
          errors.push msg
        else
          raise msg
        end
      end
    end
  end
end
