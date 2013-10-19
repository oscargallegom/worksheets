if Rails.env.staging? || Rails.env.production?
  # Unix version
  WickedPdf.config = { :exe_path => Rails.root.to_s + "/bin/wkhtmltopdf-amd64"  }
else
  # assume Windows environment
  WickedPdf.config = { :exe_path => 'C:\Program Files\wkhtmltopdf\wkhtmltopdf.exe'
  }
end




