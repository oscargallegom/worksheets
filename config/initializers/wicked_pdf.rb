if Rails.env.staging? || Rails.env.production?
  # Unix version
  WickedPdf.config = {
  :exe_path => Rails.root.join('bin', 'wkhtmltopdf-i386').to_s,
}
else
  # assume Windows environment
  WickedPdf.config = { :exe_path => 'C:\Program Files\wkhtmltopdf\wkhtmltopdf.exe'
  }
end




