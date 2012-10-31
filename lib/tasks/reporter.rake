desc "Generate CSV reports of reservations etc"
task :generate_reports => :environment do
  require 'reporter'
  Reporter.new.report
end