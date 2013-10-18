WickedPdf.config do |config|
 # if Rails.env.staging? || Rails.env.production?
    config.exe_path = Rails.root.to_s + "/bin/wkhtmltopdf-amd64"
    #config.exe_path = Rails.root.join('bin', 'wkhtmltopdf-amd64').to_s
#else
#  config.exe_path = 'C:\Program Files\wkhtmltopdf\wkhtmltopdf.exe'
#end
  end


