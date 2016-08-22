if Rails.env.staging? || Rails.env.production?
  # Unix version
  WickedPdf.config = {
  :exe_path => "#{ENV['GEM_HOME']}/gems/wkhtmltopdf-binary-#{Gem.loaded_specs['wkhtmltopdf-binary'].version}/bin/wkhtmltopdf_linux_amd64"
}
else
  # assume Windows environment
  WickedPdf.config = 
  { :exe_path => "#{ENV['GEM_HOME']}/gems/wkhtmltopdf-binary-#{Gem.loaded_specs['wkhtmltopdf-binary'].version}/bin/wkhtmltopdf_darwin_x86"
  }
end




