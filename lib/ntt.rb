require 'nokogiri'
require 'open-uri'

module Ntt

  MAX_ATTEMPTS = 10

  def test(field)

    attempts=0

    doc = nil
    begin
      #xml = 'file'
      #xml = buildXml(field)

=begin

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
=end
    end


  end

  def buildXml(field)

    state = field.farm.state.abbreviation
    fips = field.watershed_segment.fips
    customer = current_user.id

    xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><Navigation><StartInfo><SIID>start</SIID><State>#{state}</State><County>#{fips}</County><Customer>#{customer}</Customer></StartInfo>"

    # sum length of all strips
    fieldsWidth= 0
    field.strips.each do |strip|
      fieldsWidth = fieldsWidth + strip.length unless strip.length == nil
    end

    field.strips.each do |strip|
      fiid = '001'

      fieldArea = field.is_acres_from_map ? field.acres_from_map : field.acres_from_user

      if (field.strips.length == 1) # if no strip the area is the field area
        area = fieldArea
      else # otherwise it is a fraction of the field area
        area = strip.length * fieldArea / fieldsWidth * 0.405
      end

      tileDrainDepth = field.tile_drainage_depth==nil ? '' : field.tile_drainage_depth * 25.4
      irrigation = field.irrigation_id
      efficiency = (field.irrigation_id==0) ? '' : field.efficiency
      fertigation_n = (field.irrigation_id==0 || field.irrigation_id==502) ? '' : field.fertigation_n
      width = field.strips.length==1 ? '' : strip.length * 0.3048

      xml = xml + "<FieldInfo><FIID>#{fiid}</FIID><Area>#{area}</Area><TileDrainD>#{tileDrainDepth}</TileDrainD><Irrigation>#{irrigation}</Irrigation><IrrEff>#{efficiency}</IrrEff><NFertInIrrg>#{fertigation_n}</NFertInIrrg><Width>#{width}</Width></FieldInfo>"

      # SoilInfo section
      field.soils.each do |soil|

        soil_area = soil.percent * area
        map_unit_key = soil.map_unit_key
        map_unit_symbol = soil.map_unit_symbol
        hydrologic_group = soil.hydrologic_group
        component_name = soil.component_name
        p_test = 123 # TODO: implement
        slope = soil.slope
        percent_sand = soil.percent_sand
        percent_silt = soil.percent_silt
        percent_clay = soil.percent_clay
        bulk_density = soil.bulk_density
        organic_carbon = soil.organic_carbon


        xml = xml + "<SoilInfo><area>#{soil_area}</area><MapUnit>#{map_unit_key}</MapUnit><MapSymbol>#{map_unit_symbol}</MapSymbol><Group>#{hydrologic_group}</Group><Component>#{component_name}</Component><PTest>#{p_test}</PTest><SoilSlope>#{slope}</SoilSlope><Sand>#{percent_sand}</Sand><Silt>#{percent_silt}</Silt><Clay>#{percent_clay}</Clay><BD>#{bulk_density}</BD><OM>#{organic_carbon}</OM></SoilInfo>"

      end

      # grazingInfo section

      field_id = '001'
      mid = 'TBD' # TODO: Mindy to find out what it is


      stip.crop_rotations do |crop_rotation|
        crop_rotation.grazing_livestocks do |grazing_livestock|

          animal_units = grazing_livestock.animal_units
          animal_id = grazing_livestock.animal_id
          hours_grazed = grazing_livestock.hours_grazed
          days_grazed = grazing_livestock.days_grazed
          precision_feeding = grazing_livestock.precision_feeding ? 1 : 0

          xml = xml + "<grazingInfo><Mid>#{mid}</Mid><fieldId>#{field_id}</fieldId><OpVal2>#{animal_units}</OpVal2><OpVal3>#{animal_id}</OpVal3><OpVal5>#{hours_grazed}</OpVal5><OpVal7>#{days_grazed}</OpVal7><OpVal8>#{precision_feeding}</OpVal8></grazingInfo>"

        end

      end

      # ManagementInfo section



    end
  end


end