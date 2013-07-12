require 'nokogiri'
require 'open-uri'
require 'net/http'

module Ntt

  MAX_ATTEMPTS = 0

  def callNtt(field)

    attempts=0
    doc = nil

    begin

      xml = URI.escape(buildXml(field).gsub('<', '[').gsub('>', ']'))

      #params = {'input' => xml }
      #url = URI.parse(URL_NTT)
      #resp, data = Net::HTTP.post_form(url, params)
      #puts resp.inspect
      #puts data.inspect


      doc = Nokogiri::XML(open(URL_NTT + '?input=' + 'file'))


      if (!doc.nil?)
        # Do something about the persistent error
        # so that you don't try to access a nil
        # doc later on.
        #@hash = Hash.from_xml((doc.xpath('//Results')).to_s)['Results']
        #pp @hash['ID']

        return [true, doc]

      end

    rescue Exception => ex
      attempts = attempts + 1
      retry if (attempts < MAX_ATTEMPTS)
      return [false, ex]
    end
  end


  def buildXml(field)

    begin

    state = field.farm.state.abbreviation
    fips = field.watershed_segment.fips
    customer = current_user.id

    mid = 0 # management info id

    xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><Navigation><StartInfo><SIID>start</SIID><State>#{state}</State><County>#{fips}</County><Customer>#{customer}</Customer></StartInfo>"

    # sum length of all strips
    fieldsWidth= 0
    field.strips.each do |strip|
      fieldsWidth = fieldsWidth + strip.length unless strip.length == nil
    end

    field.strips.each_with_index do |strip, strip_index|
      strip_id = (strip_index+1).to_s

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
      width = field.strips.length==1 ? '' : strip.length.to_f * 0.3048

      xml = xml + "<FieldInfo><FIID>#{strip_id}</FIID><Area>#{area}</Area><TileDrainD>#{tileDrainDepth}</TileDrainD><Irrigation>#{irrigation}</Irrigation><IrrEff>#{efficiency}</IrrEff><NFertInIrrg>#{fertigation_n}</NFertInIrrg><Width>#{width}</Width></FieldInfo>"

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

      strip.crop_rotations.each_with_index do |crop_rotation, crop_rotation_index|
        crop_id = crop_rotation.crop_id

        # grazingInfo section only available for permanent pasture
        if (field.field_type_id == 2)
          grazing_operation = '426'


          crop_rotation.grazing_livestocks.each_with_index do |grazing_livestock, grazing_livestock_index|

            mid = mid + 1

            animal_units = grazing_livestock.animal_units

            start_date_year = grazing_livestock.start_date_year
            start_date_month = grazing_livestock.start_date_month
            start_date_day = grazing_livestock.start_date_day


            xml = xml + "<ManagementInfo><Operation>#{grazing_operation}</Operation><OpVal2>#{animal_units}</OpVal2><Year>#{start_date_year}</Year><Month>#{start_date_month}</Month><Day>#{start_date_day}</Day><Crop>#{crop_id}</Crop><FieldId>#{strip_id}</FieldId><OpVal1>0</OpVal1><OpVal3>0</OpVal3><OpVal4>0</OpVal4><OpVal5>0</OpVal5><OpVal6>0</OpVal6><OpVal7>0</OpVal7><OpVal8>0</OpVal8><MID>#{mid}</MID></ManagementInfo>"


            animal_id = grazing_livestock.animal_id
            hours_grazed = grazing_livestock.hours_grazed
            days_grazed = grazing_livestock.days_grazed
            precision_feeding = grazing_livestock.precision_feeding ? 1 : 0

            xml = xml + "<grazingInfo><FieldId>#{strip_id}</FieldId><MID>#{mid}</MID><OpVal1>0</OpVal1><OpVal2>#{animal_units}</OpVal2><OpVal3>#{animal_id}</OpVal3><OpVal4>0</OpVal4><OpVal5>#{hours_grazed}</OpVal5><OpVal6>0</OpVal6><OpVal7>#{days_grazed}</OpVal7><OpVal8>#{precision_feeding}</OpVal8></grazingInfo>"

          end


        end

        # Planting section applicable to pasture, hay and crop only
        if (field.field_type_id <= 3)
          mid = mid + 1

          planting_operation = field.field_type_id != 2 ? crop_rotation.planting_method_id : 132

          plant_date_year = field.field_type_id != 2 ? crop_rotation.plant_date_year : 0
          plant_date_month = field.field_type_id != 2 ? crop_rotation.plant_date_month : 0
          plant_date_day = field.field_type_id != 2 ? crop_rotation.plant_date_day : 0

          seeding_rate = field.field_type_id != 2 ? crop_rotation.seeding_rate : 0
          cover_crop_id = (field.field_type_id == 1 && crop_rotation.is_cover_crop) ? crop_rotation.cover_crop_id : 0
          cover_crop_planting_method_id = (field.field_type_id == 1 && crop_rotation.is_cover_crop) ? crop_rotation.cover_crop_planting_method_id : 0
          is_permanent_pasture = field.field_type_id == 2 ? 1 : 0

          xml = xml + "<ManagementInfo><Operation>#{planting_operation}</Operation><Year>#{plant_date_year}</Year><Month>#{plant_date_month}</Month><Day>#{plant_date_day}</Day><Crop>#{crop_id}</Crop><FieldId>#{strip_id}</FieldId><OpVal1>0</OpVal1><OpVal2>0</OpVal2><OpVal3>0</OpVal3><OpVal4>0</OpVal4><OpVal5>#{seeding_rate}</OpVal5><OpVal6>#{cover_crop_id}</OpVal6><OpVal7>#{cover_crop_planting_method_id}</OpVal7><OpVal8>#{is_permanent_pasture}</OpVal8><MID>#{mid}</MID></ManagementInfo>"

          # Commercial fertilizer
          crop_rotation.commercial_fertilizer_applications.each do |commercial_fertilizer_application|

            mid = mid + 1
            commercial_fertilizer_operation = 580

            application_date_year = commercial_fertilizer_application.application_date_year
            application_date_month = commercial_fertilizer_application.application_date_month
            application_date_day = commercial_fertilizer_application.application_date_day

            total_n_applied = commercial_fertilizer_application.total_n_applied.to_f * 1.12
            total_p_applied = commercial_fertilizer_application.total_p_applied.to_f * 1.12

            incorporation_depth = commercial_fertilizer_application.is_incorporated ? (commercial_fertilizer_application.incorporation_depth * 25.4) : 0

            # for nitrogen
            xml = xml + "<ManagementInfo><Operation>#{commercial_fertilizer_operation}</Operation><Year>#{application_date_year}</Year><Month>#{application_date_month}</Month><Day>#{application_date_day}</Day><Crop>#{crop_id}</Crop><FieldId>#{strip_id}</FieldId><OpVal1>1</OpVal1><OpVal2>#{total_n_applied}</OpVal2><OpVal3>#{incorporation_depth}</OpVal3><OpVal4>0</OpVal4><OpVal5>0</OpVal5><OpVal6>0</OpVal6><OpVal7>0</OpVal7><OpVal8>0</OpVal8><MID>#{mid}</MID></ManagementInfo>"

            # for phosphorus
            xml = xml + "<ManagementInfo><Operation>#{commercial_fertilizer_operation}</Operation><Year>#{application_date_year}</Year><Month>#{application_date_month}</Month><Day>#{application_date_day}</Day><Crop>#{crop_id}</Crop><FieldId>#{strip_id}</FieldId><OpVal1>2</OpVal1><OpVal2>#{total_p_applied}</OpVal2><OpVal3>#{incorporation_depth}</OpVal3><OpVal4>0</OpVal4><OpVal5>0</OpVal5><OpVal6>0</OpVal6><OpVal7>0</OpVal7><OpVal8>0</OpVal8><MID>#{mid}</MID></ManagementInfo>"

          end

          # Other tillage operation

          crop_rotation.tillage_operations.each do |tillage_operation|
            mid = mid + 1
            operation_code = tillage_operation.tillage_operation_type_id

            start_date_year = tillage_operation.start_date_year
            start_date_month = tillage_operation.start_date_month
            start_date_day = tillage_operation.start_date_day

            xml = xml + "<ManagementInfo><Operation>#{operation_code}</Operation><Year>#{start_date_year}</Year><Month>#{start_date_month}</Month><Day>#{start_date_day}</Day><Crop>#{crop_id}</Crop><FieldId>#{strip_id}</FieldId><OpVal1>0</OpVal1><OpVal2>0</OpVal2><OpVal3>0</OpVal3><OpVal4>0</OpVal4><OpVal5>0</OpVal5><OpVal6>0</OpVal6><OpVal7>0</OpVal7><OpVal8>0</OpVal8><MID>#{mid}</MID></ManagementInfo>"

          end

          # end of season
          crop_rotation.end_of_seasons.each do |end_of_season|

            mid = mid + 1
            operation_code = end_of_season.end_of_season_type_id

            year = end_of_season.year
            month = end_of_season.month
            day = end_of_season.day

            # if cover crop (only for crop)
            is_cover_crop = (field.field_type_id == 1 && crop_rotation.is_cover_crop) ? 10 : 0

            xml = xml + "<ManagementInfo><Operation>#{operation_code}</Operation><Year>#{year}</Year><Month>#{month}</Month><Day>#{day}</Day><Crop>#{crop_id}</Crop><FieldId>#{strip_id}</FieldId><OpVal1>0</OpVal1><OpVal2>0</OpVal2><OpVal3>0</OpVal3><OpVal4>0</OpVal4><OpVal5>0</OpVal5><OpVal6>#{is_cover_crop}</OpVal6><OpVal7>0</OpVal7><OpVal8>0</OpVal8><MID>#{mid}</MID></ManagementInfo>"

          end

          # manure fertilizer application
          crop_rotation.manure_fertilizer_applications.each do |manure_fertilizer_application|

            mid = mid + 1
            operation_code = manure_fertilizer_application.manure_consistency_id

            application_date_year = manure_fertilizer_application.application_date_year
            application_date_month = manure_fertilizer_application.application_date_month
            application_date_day = manure_fertilizer_application.application_date_day

            manure_application_code = '56'

            application_rate = (manure_fertilizer_application.application_rate.to_f * 2000.0) * ((100 - manure_fertilizer_application.moisture_content.to_f) / 100.0) * 1.121

            incorporation_depth = manure_fertilizer_application.is_incorporated ? (manure_fertilizer_application.incorporation_depth.to_f * 25.4) : 0

            n_fraction = manure_fertilizer_application.total_n_concentration.to_f / 2000.0 / ((100 - manure_fertilizer_application.moisture_content.to_f) / 100.0)

            # if total p
            if (manure_fertilizer_application.p_type_id == 1)
              p_fraction = manure_fertilizer_application.p_concentration.to_f / 2000.0 / ((100 - manure_fertilizer_application.moisture_content.to_f) / 100.0)
            else # P205
              p_fraction = manure_fertilizer_application.p_concentration.to_f / 0.74 / 2000.0 / ((100 - manure_fertilizer_application.moisture_content.to_f) / 100.0) # TODO:  Mindy to check 0.74
            end


            # need to get the last 2 digits of the ID since they are shared by several animals
            manure_type_id = manure_fertilizer_application.manure_type_id.to_s[12]


            # only for swine and poultry
            manure_treatment = 0
            if (manure_fertilizer_application.manure_type != nil)
              if (manure_fertilizer_application.manure_type.manure_type_category_id == 2 && manure_fertilizer_application.is_precision_feeding) #dairy
                manure_treatment = 1
              elsif (manure_fertilizer_application.manure_type.manure_type_category_id == 3 && manure_fertilizer_application.is_phytase_treatment) # swine
                manure_treatment = 2
              elsif (manure_fertilizer_application.manure_type.manure_type_category_id == 4 && manure_fertilizer_application.is_phytase_treatment && manure_fertilizer_application.is_poultry_litter_treatment)
                manure_treatment = 23
              elsif (manure_fertilizer_application.manure_type.manure_type_category_id == 4 && manure_fertilizer_application.is_phytase_treatment && !manure_fertilizer_application.is_poultry_litter_treatment)
                manure_treatment = 2
              elsif (manure_fertilizer_application.manure_type.manure_type_category_id == 4 && !manure_fertilizer_application.is_phytase_treatment && manure_fertilizer_application.is_poultry_litter_treatment)
                manure_treatment = 3
              end
            end

            xml = xml + "<ManagementInfo><Operation>#{operation_code}</Operation><Year>#{application_date_year}</Year><Month>#{application_date_month}</Month><Day>#{application_date_day}</Day><Crop>#{crop_id}</Crop><FieldId>#{strip_id}</FieldId><OpVal1>#{manure_application_code}</OpVal1><OpVal2>#{application_rate}</OpVal2><OpVal3>#{incorporation_depth}</OpVal3><OpVal4>#{n_fraction}</OpVal4><OpVal5>#{manure_type_id}</OpVal5><OpVal6>0</OpVal6><OpVal7>#{p_fraction}</OpVal7><OpVal8>#{manure_treatment}</OpVal8><MID>#{mid}</MID></ManagementInfo>"

          end


        end
      end
    end
    xml << "</Navigation>"

    rescue Exception => ex
      xml = 'Error generating xml: ' << ex.to_s
    end

    end



end