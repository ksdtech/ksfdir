class FamilyStudent
  include DataMapper::Resource
  belongs_to :family
  belongs_to :student

  property :id, Serial
  property :position, Integer
  property :grade_level, Integer
  property :reg_grade_level, Integer
  property :username, String
  property :password, String
  
  def password_lines
    [ "Login for #{student.full_name} (#{student.short_grade_level})", 
      "User name: #{self.username}",
      "Password: #{self.password}" ]
  end
  
  def primary?
    position == 0
  end
  
  def secondary?
    position > 0
  end
end

class FamilyEmail
  include DataMapper::Resource
  belongs_to :family
  
  property :id, Serial
  property :email, String
  property :first_name, String
  property :last_name, String
end

class Family
  include DataMapper::Resource
  has n, :family_students, :order => [ :reg_grade_level.desc, :position.asc ]
  has n, :students, :through => :family_students
  has n, :family_emails

  property :id, Integer, :key => true
  property :phone, String
  property :address_1, String
  property :city, String
  property :state, String
  property :zip, String
  
  def last_name
    name, freq = family_students.inject({}) do |h, fs|
      h[fs.student.last_name] ||= 0
      h[fs.student.last_name] += 1
      h
    end.sort { |a, b| b[1] <=> a[1] }.first
    name
  end
  
  def mailing_address_fields
    [ address_1, city, state, zip ]
  end
  
  def parents_of
    "Parents of #{self.students.first.full_name}"
  end
  
  def primary?
    family_students.any? { |fs| fs.primary? }
  end
  
  def secondary?
    family_students.any? { |fs| fs.secondary? }
  end

  def reg_started?
    students.any? { |s| !s.form1_updated_at.nil? || !s.form3_updated_at.nil? || !s.form9_updated_at.nil? }
  end
  
  def reg_completed?
    students.all? { |s| s.reg_completed? }
  end
  
  def reg_incompletes
    students.inject([]) do |a, s| 
      a << "#{s.full_name} - status: #{s.reg_will_attend}#{s.form1_updated_at ? ', form1' : ''}#{s.form3_updated_at ? ', form3' : ''}#{s.form9_updated_at ? ', form9' : ''}" unless s.reg_completed?
      a
    end
  end

  def has_underscore_email?
    family_emails.size > 0 && family_emails.all? { |e| e.email.match(/_/) }
  end
  
  def add_student(student, username, password, position)
    fs = FamilyStudent.new
    fs.family_id = self.id
    fs.student_student_number = student.student_number
    fs.grade_level = student.grade_level
    fs.reg_grade_level = student.reg_grade_level
    fs.username = username
    fs.password = password
    fs.position = position
    fs.save
    return fs
  end
  
  def add_email(email, first, last)
    return nil if email.nil? || email.empty?
    fe = FamilyEmail.first(:email => email, :family_id => self.id)
    if fe.nil?
      fe = FamilyEmail.new
      fe.family_id = self.id
      fe.email = email
      fe.first_name = first
      fe.last_name = last
      fe.save
    end
    return fe
  end

  def password_lines
    lines = [ ]
    self.family_students.each do |fs|
      lines.push('') unless lines.empty?
      lines += fs.password_lines
    end
    lines
  end
  
  def student_lines
    self.family_students.collect do |fs|
      "#{fs.student.full_name} (#{fs.student.short_grade_level})"
    end
  end
  
  def id_line
    pri = primary? ? ' pri' : ''
    sec = secondary? ? ' sec' : ''
    status = reg_completed? ? ' complete' : (reg_started? ? ' started' : '')
    "F#{self.id}#{pri}#{sec}#{status}" 
  end
  
  def info_lines
    [ id_line ] + student_lines + [ address_1, "#{city}, #{state} #{zip}", "tel: #{phone}" ]
  end
end
