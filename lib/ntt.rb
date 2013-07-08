require 'nokogiri'
require 'open-uri'

module Ntt

  MAX_ATTEMPTS = 10

  def test()

    attempts=0

    doc = nil
    begin
      xml = 'file'
      doc = Nokogiri::XML(open(URL_NTT + '?input=' + xml))
    rescue Exception => ex
      attempts = attempts + 1
      retry if(attempts < MAX_ATTEMPTS)
    end

    if(!doc.nil?)
      # Do something about the persistent error
      # so that you don't try to access a nil
      # doc later on.
      @hash = Hash.from_xml((doc.xpath('//Results')).to_s)['Results']
      pp @hash['ID']
    end


end


end