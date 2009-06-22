class Student
  include DataMapper::Resource
  
  property :student_number, Integer, :key => true
  property :city, String, :length => 30
  property :enroll_status, Integer, :null => false, :default => 0
  property :father, String, :length => 30 
  property :father2_cell, String, :length => 30
  property :father2_email, String, :length => 60
  property :father2_first, String, :length => 30
  property :father2_home_phone, String, :length => 30
  property :father2_last, String, :length => 30
  property :father2_staff_id, Integer 
  property :father2_work_phone, String, :length => 30
  property :father_cell, String, :length => 30
  property :father_email, String, :length => 60
  property :father_first, String, :length => 30
  property :father_home_phone, String, :length => 30
  property :father_staff_id, Integer 
  property :father_work_phone, String, :length => 30
  property :first_name, String, :length => 30
  property :form1_updated_at, String, :length => 30
  property :form3_updated_at, String, :length => 30
  property :form9_updated_at, String, :length => 30
  property :gender, String, :length => 1
  property :grade_level, Integer, :null => false, :default => 0
  property :home2_city, String, :length => 30
  property :home2_id, Integer, :null => false, :default => 0
  property :home2_phone, String, :length => 30
  property :home2_state, String, :length => 2
  property :home2_street, String, :length => 60
  property :home2_zip, String, :length => 15
  property :home_id, Integer, :null => false, :default => 0
  property :home_phone, String, :length => 30
  property :last_name, String, :length => 30
  property :mailing2_city, String, :length => 30
  property :mailing2_state, String, :length => 2
  property :mailing2_street, String, :length => 60
  property :mailing2_zip, String, :length => 15
  property :mailing_city, String, :length => 30
  property :mailing_state, String, :length => 2
  property :mailing_street, String, :length => 60
  property :mailing_zip, String, :length => 15
  property :middle_name, String, :length => 30
  property :mother, String, :length => 30 
  property :mother2_cell, String, :length => 30
  property :mother2_email, String, :length => 60
  property :mother2_first, String, :length => 30
  property :mother2_home_phone, String, :length => 30
  property :mother2_last, String, :length => 30
  property :mother2_staff_id, Integer 
  property :mother2_work_phone, String, :length => 30
  property :mother_cell, String, :length => 30
  property :mother_email, String, :length => 60
  property :mother_first, String, :length => 30
  property :mother_home_phone, String, :length => 30
  property :mother_staff_id, Integer
  property :mother_work_phone, String, :length => 30
  property :network_id, String, :length => 30
  property :nickname, String, :length => 30
  property :reg_grade_level, Integer 
  property :reg_will_attend, String, :length => 15
  property :schoolid, Integer, :null => false, :default => 0 
  property :state, String, :length => 2
  property :street, String, :length => 60
  property :student_web_id, String, :length => 30
  property :student_web_password, String, :length => 30
  property :web_id, String, :length => 30
  property :web_password, String, :length => 30
  property :zip, String, :length => 15
#  property :alert_medical, Text 
#  property :alert_medical_symptoms, Text 
#  property :alert_medical_what, Text 
#  property :allergies, Text 
#  property :allergies_benadryl, Boolean 
#  property :allergies_drugs, Boolean 
#  property :allergies_epi_pen, Boolean 
#  property :allergies_food, Boolean 
#  property :allergies_insects, Boolean 
#  property :allergies_other, Boolean 
#  property :allergies_severe, Boolean 
#  property :allowwebaccess, Boolean 
#  property :asthma, Boolean 
#  property :asthma_inhaler, Boolean 
#  property :asthma_medication, Boolean 
#  property :behavior_issues, Text 
#  property :behavior_problems, Boolean 
#  property :ca_birthplace_city, String, :length => 30
#  property :ca_birthplace_country, String, :length => 2 
#  property :ca_birthplace_state, String, :length => 2
#  property :ca_dateenroll, String, :length => 10 
#  property :ca_daterfep, String, :length => 10 
#  property :ca_ethnaa, Boolean 
#  property :ca_ethnai, Boolean 
#  property :ca_ethnaspiai, Boolean 
#  property :ca_ethnaspica, Boolean 
#  property :ca_ethnaspich, Boolean 
#  property :ca_ethnaspigu, Boolean 
#  property :ca_ethnaspiha, Boolean 
#  property :ca_ethnaspihm, Boolean 
#  property :ca_ethnaspija, Boolean 
#  property :ca_ethnaspiko, Boolean 
#  property :ca_ethnaspila, Boolean 
#  property :ca_ethnaspioa, Boolean 
#  property :ca_ethnaspiopi, Boolean 
#  property :ca_ethnaspisa, Boolean 
#  property :ca_ethnaspita, Boolean 
#  property :ca_ethnaspivi, Boolean 
#  property :ca_ethnfi, Boolean 
#  property :ca_ethnla, Boolean 
#  property :ca_ethnwh, Boolean 
#  property :ca_firstusaschooling, String, :length => 10 
#  property :ca_homelanguage, String, :length => 2
#  property :ca_langfluency, String, :length => 1
#  property :ca_namesuffix, String, :length => 30
#  property :ca_parented, String, :length => 2
#  property :contact1_1, String, :length => 30
#  property :contact1_2, String, :length => 30
#  property :contact1_3, String, :length => 30
#  property :contact2_1, String, :length => 30
#  property :contact2_2, String, :length => 30
#  property :contact2_3, String, :length => 30
#  property :custody_orders, Boolean 
#  property :dental_carrier, String, :length => 60
#  property :dental_policy, String, :length => 30
#  property :dentist_name, String, :length => 60
#  property :dentist_phone, String, :length => 30
#  property :diabetes, Boolean 
#  property :diabetes_insulin, Boolean 
#  property :districtentrydate, String 
#  property :districtentrygradelevel, String 
#  property :dob, String, :length => 10 
#  property :doctor2_name, String, :length => 60
#  property :doctor2_phone, String, :length => 30
#  property :doctor_name, String, :length => 60
#  property :doctor_phone, String, :length => 30
#  property :electives_5_music, String, :length => 15
#  property :electives_6_band, String 
#  property :electives_6_choir, String 
#  property :electives_6_pa, String 
#  property :electives_7_band, String 
#  property :electives_7_choir, String 
#  property :electives_8_band, String 
#  property :electives_8_choir, String 
#  property :electives_8_enrich1, String, :length => 15
#  property :electives_8_enrich2, String, :length => 15
#  property :electives_8_enrich3, String, :length => 15
#  property :emerg_1_alt_phone, String, :length => 30
#  property :emerg_1_alt_ptype, String, :length => 15
#  property :emerg_1_first, String, :length => 30
#  property :emerg_1_ptype, String, :length => 15
#  property :emerg_1_rel, String, :length => 15
#  property :emerg_2_alt_phone, String, :length => 30
#  property :emerg_2_alt_ptype, String, :length => 15
#  property :emerg_2_first, String, :length => 30
#  property :emerg_2_ptype, String, :length => 15
#  property :emerg_2_rel, String, :length => 15
#  property :emerg_3_alt_phone, String, :length => 30
#  property :emerg_3_alt_ptype, String, :length => 15
#  property :emerg_3_first, String, :length => 30
#  property :emerg_3_last, String, :length => 30
#  property :emerg_3_phone, String, :length => 30
#  property :emerg_3_ptype, String, :length => 15
#  property :emerg_3_rel, String, :length => 15
#  property :emerg_contact_1, String, :length => 30
#  property :emerg_contact_2, String, :length => 30
#  property :emerg_phone_1, String, :length => 30
#  property :emerg_phone_2, String, :length => 30
#  property :emerg_x_alt_phone, String, :length => 30
#  property :emerg_x_alt_ptype, String, :length => 15
#  property :emerg_x_first, String, :length => 30
#  property :emerg_x_last, String, :length => 30
#  property :emerg_x_phone, String, :length => 30
#  property :emerg_x_ptype, String, :length => 15
#  property :emerg_x_rel, String, :length => 15
#  property :emergency_hospital, String, :length => 30
#  property :emergency_meds, Boolean 
#  property :emergency_meds_complete, Boolean 
#  property :entrydate, String, :length => 10
#  property :ethnicity, String, :length => 3
#  property :exitcode, String, :length => 3 
#  property :eyeglasses, Boolean 
#  property :eyeglasses_always, Boolean 
#  property :eyeglasses_board, Boolean 
#  property :eyeglasses_reading, Boolean 
#  property :father2_email2, String, :length => 60
#  property :father2_employer, String, :length => 30
#  property :father2_employer_address, String, :length => 30
#  property :father2_isguardian, Boolean 
#  property :father2_pager, String 
#  property :father2_rel, String, :length => 15
#  property :father_email2, String, :length => 60
#  property :father_employer, String, :length => 30
#  property :father_employer_address, String, :length => 30
#  property :father_isguardian, Boolean 
#  property :father_pager, String 
#  property :father_rel, String, :length => 15
#  property :form1_updated_by, String, :length => 15
#  property :form2_updated_at, String, :length => 30
#  property :form2_updated_by, String, :length => 15
#  property :form3_updated_by, String, :length => 15
#  property :form4_updated_at, String, :length => 30
#  property :form4_updated_by, String, :length => 15
#  property :form5_updated_at, String, :length => 30
#  property :form5_updated_by, String, :length => 15
#  property :form6_updated_at, String, :length => 30
#  property :form6_updated_by, String, :length => 15
#  property :form7_updated_at, String, :length => 30
#  property :form7_updated_by, String, :length => 15
#  property :form8_updated_at, String, :length => 30
#  property :form8_updated_by, String, :length => 15
#  property :form9_updated_by, String, :length => 15
#  property :guardianemail, String 
#  property :h_hearing_aid, String 
#  property :h_last_eye_exam, String 
#  property :health_ins_type, String 
#  property :home2_no_inet_access, Boolean 
#  property :home2_printed_material, Boolean 
#  property :home2_spanish_material, Boolean 
#  property :home_no_inet_access, Boolean 
#  property :home_printed_material, Boolean 
#  property :home_room, String, :length => 30
#  property :home_spanish_material, Boolean 
#  property :homeroom_teacher, String, :length => 30
#  property :homeroom_teacherfirst, String, :length => 30
#  property :illness_desc, String 
#  property :illness_recent, Boolean 
#  property :lang_adults_primary, String, :length => 2
#  property :lang_earliest, String, :length => 2
#  property :lang_other, String, :length => 2
#  property :lang_spoken_to, String, :length => 2
#  property :lastfirst, String, :length => 60
#  property :lives_with_rel, String, :length => 15
#  property :med1_dosage, String, :length => 30
#  property :med1_hours, String, :length => 30
#  property :med1_name, String, :length => 30
#  property :med2_dosage, String, :length => 30
#  property :med2_hours, String, :length => 30
#  property :med2_name, String, :length => 30
#  property :med3_dosage, String, :length => 30
#  property :med3_hours, String, :length => 30
#  property :med3_name, String, :length => 30
#  property :medi_cal_num, String, :length => 30
#  property :medical_accom, Boolean 
#  property :medical_accom_desc, Text 
#  property :medical_carrier, String, :length => 60
#  property :medical_considerations, Text 
#  property :medical_other, Boolean 
#  property :medical_policy, String, :length => 30
#  property :medication_summary, String 
#  property :mother2_email2, String, :length => 60
#  property :mother2_employer, String, :length => 30
#  property :mother2_employer_address, String, :length => 30
#  property :mother2_isguardian, Boolean 
#  property :mother2_pager, String 
#  property :mother2_rel, String, :length => 15
#  property :mother_email2, String, :length => 60
#  property :mother_employer, String, :length => 30
#  property :mother_employer_address, String, :length => 30
#  property :mother_isguardian, Boolean 
#  property :mother_pager, String, :length => 30
#  property :mother_rel, String, :length => 15
#  property :movement_limits, Boolean 
#  property :movement_limits_desc, Text 
#  property :network_password, String, :length => 30
#  property :optical_carrier, String, :length => 60
#  property :optical_policy, String, :length => 30
#  property :prescriptions, Text 
#  property :prev_school_permission, String 
#  property :previous_school_address, String, :length => 60
#  property :previous_school_city, String, :length => 30
#  property :previous_school_grade_level, String, :length => 15
#  property :previous_school_name, String, :length => 30
#  property :previous_school_phone, String, :length => 30
#  property :pub_waiver_public, Boolean 
#  property :pub_waiver_restricted, Boolean 
#  property :release_authorization, Boolean 
#  property :requires_meds, Boolean 
#  property :responsibility_date, String, :length => 10 
#  property :responsibility_signed, Boolean
#  property :school_meds, Boolean 
#  property :school_meds_complete, Boolean 
#  property :schoolentrydate, String, :length => 10  
#  property :schoolentrydate_ca, String, :length => 10  
#  property :schoolentrygradelevel, Integer 
#  property :seizures, Boolean 
#  property :seizures_medication, Boolean 
#  property :sibling1_dob, String, :length => 10  
#  property :sibling1_name, String, :length => 30
#  property :sibling2_dob, String, :length => 10  
#  property :sibling2_name, String, :length => 30
#  property :sibling3_dob, String, :length => 10  
#  property :sibling3_name, String, :length => 30
#  property :sibling4_dob, String, :length => 10  
#  property :sibling4_name, String, :length => 30
#  property :signature_1, String, :length => 60
#  property :signature_2, String, :length => 60
#  property :student_allowwebaccess, Boolean 
#  property :vol_first, String, :length => 30
#  property :vol_help, Boolean 
#  property :vol_last, String, :length => 30
#  property :vol_phone, String, :length => 30
#  property :vol_qualifications, Text 
 
  def school_name
    { 103 => 'Bacich', 104 => 'Kent' }[schoolid] || 'Unknown'
  end
  
  def short_grade_level
    grade_level == 0 ? 'KG' : (grade_level <= 8 ? grade_level.to_s : 'GR')
  end
  
  def home_language
    PRIMARY_LANGUAGES[ca_homelanguage] || 'Other'
  end
    
  def home_index(family_number)
    if !family_number.nil? && family_number != 0
      return 0 if self.home_id == family_number
      return 1 if self.home2_id == family_number
    end
    nil
  end
  
  def full_name
    "#{self.first_name} #{self.last_name}".strip
  end
  
  def to_s
    rgl = reg_grade_level == 0 ? 'KG' : (reg_grade_level <= 8 ? reg_grade_level.to_s : 'GR')
    "#{full_name} (#{rgl})".strip
  end
  
  def reg_completed?
    !form1_updated_at.nil? && !reg_will_attend.nil? && 
      (reg_will_attend.match(/^nr-/) || (!form3_updated_at.nil? && !form9_updated_at.nil?))
  end
  
  class << self
    def column_names
      @col_keys ||= properties.collect { |prop| prop.name }
    end
    
    def has_attribute?(key)
      column_names.include?(key.to_sym)
    end
    
    def all_home_ids(coll=nil)
      coll ||= Student.all
      coll.inject({}) do |h, stu|
        h[stu.home_id] = 1 if stu.home_id != 0
        h[stu.home2_id] = 1 if stu.home2_id != 0
        h
      end.keys.sort
    end
    
    def stats
      stats_hash = Array.new(9) { |i| { :unconfirmed => 0, :unknown => 0, :new_district => 0, :promoting => 0, :retaining => 0, :exiting => 0 } }
      Student.all.each do |s|
        i = s.reg_grade_level
        puts i.inspect
        next if i < 0 || i > 8
        bucket = :unconfirmed
        if s.enroll_status < 0
          bucket = :new_district
        elsif !s.form1_updated_at.nil?
          bucket = case s.reg_will_attend
          when 'attending'
            s.reg_grade_level > s.grade_level ? :promoting : :retaining
          when 'nr-temporary', 'nr-permanent', 'graduating'
            :exiting
          else
            :unknown
          end
        end
        stats_hash[i][bucket] += 1
      end
      0.upto(8) do |i|
        gstats = stats_hash[i]
        puts "Grade #{i}"
        puts "Unconfirmed: #{gstats[:unconfirmed]}"
        puts "New:         #{gstats[:new_district]}"
        puts "Promoting:   #{gstats[:promoting]}"
        puts "Retaining:   #{gstats[:retaining]}"
        puts "Exiting:     #{gstats[:exiting]}"
        puts "Unknown:     #{gstats[:unknown]}" if gstats[:unknown] > 0
        puts "Expected:    #{gstats[:new_district] + gstats[:promoting] + gstats[:retaining]+ gstats[:unconfirmed]}"
        puts
      end
    end
    
    def import(fname='student.export.text', headers=true, returning_only=true)
      fname = File.join(APP_ROOT, "data/#{fname}") unless fname[0,1] == '/'
      csv_options = { :col_sep => "\t", :row_sep => "\n" }
      if headers 
        csv_options[:headers] = true
        csv_options[:header_converters] = :symbol
      end
      count = 0
      UnquotedCSV.foreach(fname, csv_options) do |row|
        count += 1
        if headers
          attrs = row.to_hash
        else
          attrs = {}
          column_names.each_with_index do |field, i|
            attrs[field] = row[i]
          end
        end
        user = import_student(attrs, returning_only)
      end
      count
    end
        
    def import_student(attrs, returning_only=true)
      student_attrs = attrs.reject { |k, v| !Student.has_attribute?(k) }
      int_convert(student_attrs, :student_number)
      student_number = student_attrs.delete(:student_number)
      
      # oops. forgot that pub_waiver fields are "yes" or "no" in PowerSchool
      # need to convert them to true or false
      int_convert(student_attrs, :enroll_status)
      int_convert(student_attrs, :schoolid)
      int_convert(student_attrs, :grade_level)
      int_convert(student_attrs, :reg_grade_level)
      
      if returning_only
        return nil unless student_attrs[:enroll_status] == 0 && student_attrs[:reg_grade_level] <= 8
      end
      return nil unless student_attrs[:enroll_status] <= 0

      puts "adding #{student_number}"
      int_convert(student_attrs, :home_id)
      int_convert(student_attrs, :home2_id)
      name_convert(student_attrs, :first_name)
      name_convert(student_attrs, :middle_name)
      name_convert(student_attrs, :last_name)
      name_convert(student_attrs, :nickname)
      name_convert(student_attrs, :mother)
      name_convert(student_attrs, :mother_first)
      name_convert(student_attrs, :father)
      name_convert(student_attrs, :father_first)
      name_convert(student_attrs, :mother2_last)
      name_convert(student_attrs, :mother2_first)
      name_convert(student_attrs, :father2_last)
      name_convert(student_attrs, :father2_first)
      name_convert(student_attrs, :network_id)
      name_convert(student_attrs, :web_id)
      name_convert(student_attrs, :student_web_id)
      email_convert(student_attrs, :mother_email)
      email_convert(student_attrs, :father_email)
      email_convert(student_attrs, :mother2_email)
      email_convert(student_attrs, :father2_email)
      state_convert(student_attrs, :state)
      state_convert(student_attrs, :mailing_state)
      state_convert(student_attrs, :home2_state)
      state_convert(student_attrs, :mailing2_state)
      
      stu = Student.new
      stu.student_number = student_number
      stu.attributes = student_attrs
      stu.save
      
      if stu.home_id != 0
        f = Family.get(stu.home_id)
        if f.nil?
          f = Family.new
          f.id = stu.home_id
          f.phone = stu.home_phone
          f.address_1 = stu.mailing_street || stu.street
          f.city = stu.mailing_city || stu.city
          f.state = stu.mailing_state || stu.state
          f.zip = stu.mailing_zip || stu.zip
          f.save
        end
        f.add_student(stu, stu.web_id, stu.web_password, 0)
        f.add_email(stu.mother_email, stu.mother_first, stu.mother)
        f.add_email(stu.father_email, stu.father_first, stu.father)
      end
      
      if stu.home2_id != 0
        f = Family.get(stu.home2_id)
        if f.nil?
          f = Family.new
          f.id = stu.home2_id
          f.phone = stu.home2_phone
          f.address_1 = stu.mailing2_street || stu.home2_street
          f.city = stu.mailing2_city || stu.home2_city
          f.state = stu.mailing2_state || stu.home2_state
          f.zip = stu.mailing2_zip || stu.home2_zip
          f.save
        end
        # student_web_id logins won't allow changes in PowerSchool
        f.add_student(stu, stu.web_id, stu.web_password, 1)
        f.add_email(stu.mother2_email, stu.mother2_first, stu.mother2_last)
        f.add_email(stu.father2_email, stu.father2_first, stu.father2_last)
      end
    end 
  end
end
