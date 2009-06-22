require "rubygems"

# require "spec/rake/spectask"
# require "config"

# file_list = Dir["spec/*_spec.rb"]
# Spec::Rake::SpecTask.new('spec') do |t|
#   t.spec_files = file_list
# end

# desc 'Default: run specs'
# task :default => 'spec'

task :environment do
  require "application"
end

namespace :db do
  desc "AutoMigrate the db (deletes data)"
  task :migrate => :environment do
    DataMapper.auto_migrate!
  end
  desc "AutoUpgrade the db (preserves data)"
  task :upgrade => :environment do
    DataMapper.auto_upgrade!
  end
end

namespace :directory do 
  desc "Import students"
  task :import => :environment do
    DataMapper.auto_migrate!
    Student.import("#{Dir.pwd}/data/student.export.text")
  end
  desc "Output text file"
  task :text => :environment do
    File.open("#{Dir.pwd}/data/directory.txt", "w") do |f|
      Directory.output_text(f, nil, false)
    end
  end
end

namespace :sinatra do
  desc "Updates or downloads the latest Sinatra build"
  task :edge do
    if !File.exists?(File.join(File.dirname(__FILE__), "vendor", "sinatra"))
      system "git submodule add git://github.com/bmizerany/sinatra.git vendor/sinatra"
    else
      system "git submodule update"
    end
  end
end