require 'nokogiri'
require 'open-uri'
require 'net/http'

module Ntt

  MAX_ATTEMPTS = 0

  def callNtt(field, is_future)
    ENV['debug'] += 'Update NTT: ' + (is_future ? 'future' : 'current') + ' (' + field.name + ') <br/>'
    puts '############################################ enter callNtt - ' + is_future.to_s
    puts Time.new

    attempts=0
    doc = nil

    begin

      success, content = buildXml(field, is_future)

      if (success)

        xml = URI.escape(content.gsub('<', '[').gsub('>', ']'))

        #doc is the xml that is returned from NTT

        #doc = Nokogiri::XML(open(URL_NTT + '?input=' + xml))

        #puts URL_NTT + '?input=' + xml
        
         uri = URI(URL_NTT)
         res = Net::HTTP.post_form(uri, 'input' => xml)
         puts res.body
         doc = Nokogiri::XML(res.body)

        if (!doc.nil?)
          return [true, doc]
        end
      else
        #content is the xml that is sent to NTT
        return [false, content]
      end

    rescue Exception => ex
      attempts = attempts + 1
      retry if (attempts < MAX_ATTEMPTS)
      return [false, ex]
    end
  end

  def buildXml(field, is_future)

    #begin

      state = field.farm.state.abbreviation
      fips = field.watershed_segment.fips unless field.watershed_segment.nil?
      if field.watershed_segment.nil?
        raise "Field '#{field.name}' is not in watershed."
      end

      customer = field.farm.owner_id #current_user.id

      mid = 0 # management info id

      xml = "<?xml version=\"1.0\" standalone=\"yes\"?><Navigation><StartInfo><SIID>start</SIID><State>#{state}</State><County>#{fips}</County><Customer>#{customer}</Customer></StartInfo>"

      # sum length of all strips
      fieldsWidth= 0
      number_of_strips = 0
      field.strips.each do |strip|
        fieldsWidth = fieldsWidth + strip.length if (strip.is_future==is_future && !strip.length.nil?)
        number_of_strips = number_of_strips + 1 if strip.is_future==is_future
      end

      strip_id = 0
      field.strips.each do |strip|

        if (strip.is_future == is_future)

          strip_id = strip_id + 1

          fieldArea = field.is_acres_from_map ? field.acres_from_map : field.acres_from_user

          if (number_of_strips == 1) # if no strip the area is the field area
            area = fieldArea*(0.404686)
          else # otherwise it is a fraction of the field area
            area = strip.length.to_f * fieldArea / fieldsWidth * 0.404686
          end

          tileDrainDepth = field.tile_drainage_depth==nil ? '' : field.tile_drainage_depth * 304.8
          irrigation = field.irrigation_id
          efficiency = (field.irrigation_id==0) ? '' : field.efficiency
          fertigation_n = (field.irrigation_id==0 || field.irrigation_id==502) ? '' : field.fertigation_n
          width = field.strips.length==1 ? 0 : strip.length.to_f * 0.3048

          xml = xml + "<FieldInfo><FIID>#{strip_id}</FIID><Area>#{area.round(3)}</Area><TileDrainD>#{tileDrainDepth}</TileDrainD><Irrigation>#{irrigation}</Irrigation><IrrEff>#{efficiency}</IrrEff><NFertInIrrg>#{fertigation_n}</NFertInIrrg><Width>#{width.round(3)}</Width></FieldInfo>"

          ########################################################
          # SoilInfo section
          ########################################################
          field.soils.each do |soil|

            soil_area = soil.percent.to_f * area
            map_unit_key = soil.map_unit_key
            map_unit_symbol = soil.map_unit_symbol
            hydrologic_group = soil.hydrologic_group
            component_name = soil.component_name
            #niccdcdpct = soil.niccdcdpct
            p_test = field.modified_p_test_value
            slope = soil.slope
            percent_sand = soil.percent_sand
            percent_silt = soil.percent_silt
            percent_clay = soil.percent_clay
            bulk_density = soil.bulk_density
            organic_carbon = soil.organic_carbon

            xml = xml + "<SoilInfo><FIID>#{strip_id}</FIID><area>#{soil_area.round(3)}</area><MapUnit>#{map_unit_key}</MapUnit><MapSymbol>#{map_unit_symbol}</MapSymbol><Group>#{hydrologic_group}</Group><Component>#{component_name}</Component><PTest>#{p_test.round(3)}</PTest><SoilSlope>#{slope}</SoilSlope><Sand>#{percent_sand}</Sand><Silt>#{percent_silt.round(4)}</Silt><Clay>#{percent_clay}</Clay><BD>#{bulk_density}</BD><OM>#{organic_carbon}</OM></SoilInfo>"

          end

          # if no soil data, the user has manually picked one
          if (field.soils.empty? && !field.soil_texture.nil?)
            soil_area = area
            map_unit_key = ''
            map_unit_symbol = ''
            hydrologic_group = ''
            component_name = ''
            p_test = field.modified_p_test_value
            slope = field.slope
            percent_sand = field.soil_texture.percent_sand
            percent_silt = field.soil_texture.percent_silt
            percent_clay = field.soil_texture.percent_clay
            bulk_density = field.soil_texture.bulk_density
            organic_carbon = field.soil_texture.organic_carbon

            xml = xml + "<SoilInfo><FIID>#{strip_id}</FIID><area>#{soil_area.round(3)}</area><MapUnit>#{map_unit_key}</MapUnit><MapSymbol>#{map_unit_symbol}</MapSymbol><Group>#{hydrologic_group}</Group><Component>#{component_name}</Component><PTest>#{p_test.round(3)}</PTest><SoilSlope>#{slope}</SoilSlope><Sand>#{percent_sand}</Sand><Silt>#{percent_silt.round(4)}</Silt><Clay>#{percent_clay}</Clay><BD>#{bulk_density}</BD><OM>#{organic_carbon}</OM></SoilInfo>"
          end

          strip.crop_rotations.each_with_index do |crop_rotation, crop_rotation_index|
            crop_code = crop_rotation.crop.code

            ########################################################
            # Grazing, section only available for permanent pasture
            ########################################################
            if (field.field_type_id == 2)
              start_grazing_operation = '426'
              end_grazing_operation = '427'

              crop_rotation.grazing_livestocks.each_with_index do |grazing_livestock, grazing_livestock_index|

                mid = mid + 1

                animal_units = grazing_livestock.animal_units

                start_date_year = grazing_livestock.start_date_year
                start_date_month = grazing_livestock.start_date_month
                start_date_day = grazing_livestock.start_date_day


                xml = xml + "<ManagementInfo><Operation>#{start_grazing_operation}</Operation><OpVal2>#{animal_units}</OpVal2><Year>#{start_date_year}</Year><Month>#{start_date_month}</Month><Day>#{start_date_day}</Day><Crop>#{crop_code}</Crop><FieldId>#{strip_id}</FieldId><OpVal1>0</OpVal1><OpVal3>0</OpVal3><OpVal4>0</OpVal4><OpVal5>0</OpVal5><OpVal6>0</OpVal6><OpVal7>0</OpVal7><OpVal8>0</OpVal8><MID>#{mid}</MID></ManagementInfo>"

                end_date_year = grazing_livestock.end_date_year
                end_date_month = grazing_livestock.end_date_month
                end_date_day = grazing_livestock.end_date_day

                xml = xml + "<ManagementInfo><Operation>#{end_grazing_operation}</Operation><Year>#{end_date_year}</Year><Month>#{end_date_month}</Month><Day>#{end_date_day}</Day><Crop>#{crop_code}</Crop><FieldId>#{strip_id}</FieldId><OpVal1>0</OpVal1><OpVal2>0</OpVal2><OpVal3>0</OpVal3><OpVal4>0</OpVal4><OpVal5>0</OpVal5><OpVal6>0</OpVal6><OpVal7>0</OpVal7><OpVal8>0</OpVal8><MID>#{mid}</MID></ManagementInfo>"


                animal_id = grazing_livestock.animal_id
                hours_grazed = grazing_livestock.hours_grazed
                precision_feeding = grazing_livestock.precision_feeding ? 1 : 0

                xml = xml + "<grazingInfo><FieldId>#{strip_id}</FieldId><MID>#{mid}</MID><OpVal1>0</OpVal1><OpVal2>#{animal_units}</OpVal2><OpVal3>#{animal_id}</OpVal3><OpVal4>0</OpVal4><OpVal5>#{hours_grazed}</OpVal5><OpVal6>0</OpVal6><OpVal7></OpVal7><OpVal8>#{precision_feeding}</OpVal8></grazingInfo>"

              end


            end
            ########################################################
            # Planting section applicable to pasture, hay and crop only
            ########################################################
            if (field.field_type_id <= 3)
              mid = mid + 1

              planting_operation = field.field_type_id != 2 ? crop_rotation.planting_method_id : 132

              plant_date_year = field.field_type_id != 2 ? crop_rotation.plant_date_year : 0
              plant_date_month = field.field_type_id != 2 ? crop_rotation.plant_date_month : 0
              plant_date_day = field.field_type_id != 2 ? crop_rotation.plant_date_day : 0

              seeding_rate = field.field_type_id != 2 ? crop_rotation.seeding_rate : 0

              is_permanent_pasture = field.field_type_id == 2 ? 1 : 0

              if field.field_type_id == 3
                xml = xml + "<ManagementInfo><Operation>132</Operation><Year>#{plant_date_year}</Year><Month>#{plant_date_month}</Month><Day>#{plant_date_day}</Day><Crop>#{crop_code}</Crop><FieldId>#{strip_id}</FieldId><OpVal1>0</OpVal1><OpVal2>0</OpVal2><OpVal3>0</OpVal3><OpVal4></OpVal4><OpVal5>#{seeding_rate}</OpVal5><OpVal6></OpVal6><OpVal7></OpVal7><OpVal8>1</OpVal8><MID>#{mid}</MID></ManagementInfo>"
              else
                xml = xml + "<ManagementInfo><Operation>#{planting_operation}</Operation><Year>#{plant_date_year}</Year><Month>#{plant_date_month}</Month><Day>#{plant_date_day}</Day><Crop>#{crop_code}</Crop><FieldId>#{strip_id}</FieldId><OpVal1>0</OpVal1><OpVal2>0</OpVal2><OpVal3>0</OpVal3><OpVal4></OpVal4><OpVal5>#{seeding_rate}</OpVal5><OpVal6></OpVal6><OpVal7></OpVal7><OpVal8>#{is_permanent_pasture}</OpVal8><MID>#{mid}</MID></ManagementInfo>"
              end

              ########################################################
              # Cover crop
              ########################################################

              if (field.field_type_id == 1 && crop_rotation.is_cover_crop)
                mid = mid + 1

                cover_crop_code = crop_rotation.cover_crop.code
                cover_crop_planting_method_id = crop_rotation.cover_crop_planting_method_id

                cover_crop_plant_date_year = crop_rotation.cover_crop_plant_date_year.to_s.rjust(2, '0')
                cover_crop_plant_date_month = crop_rotation.cover_crop_plant_date_month.to_s.rjust(2, '0')
                cover_crop_plant_date_day = crop_rotation.cover_crop_plant_date_day.to_s.rjust(2, '0')
                cover_crop_plant_date = cover_crop_plant_date_year + cover_crop_plant_date_month + cover_crop_plant_date_day

                xml = xml + "<ManagementInfo><Operation>#{planting_operation}</Operation><Year>#{cover_crop_plant_date_year}</Year><Month>#{cover_crop_plant_date_month}</Month><Day>#{cover_crop_plant_date_day}</Day><Crop>#{cover_crop_code}</Crop><FieldId>#{strip_id}</FieldId><OpVal1>0</OpVal1><OpVal2>0</OpVal2><OpVal3>0</OpVal3><OpVal4>#{cover_crop_plant_date}</OpVal4><OpVal5>#{seeding_rate}</OpVal5><OpVal6>#{cover_crop_code}</OpVal6><OpVal7>#{cover_crop_planting_method_id}</OpVal7><OpVal8></OpVal8><MID>#{mid}</MID></ManagementInfo>"

              end

              ########################################################
              # Commercial fertilizer
              ########################################################
              crop_rotation.commercial_fertilizer_applications.each do |commercial_fertilizer_application|

                mid = mid + 1
                commercial_fertilizer_operation = 580

                application_date_year = commercial_fertilizer_application.application_date_year
                application_date_month = commercial_fertilizer_application.application_date_month
                application_date_day = commercial_fertilizer_application.application_date_day

                total_n_applied = commercial_fertilizer_application.total_n_applied.to_f * 1.12
                total_p_applied = commercial_fertilizer_application.total_p_applied.to_f * 1.12
                # if P2O5
                if (commercial_fertilizer_application.p_type_id == 2)
                  total_p_applied = total_p_applied * 0.4364
                end

                incorporation_depth = commercial_fertilizer_application.is_incorporated ? (commercial_fertilizer_application.incorporation_depth * 25.4) : 0

                # for nitrogen
                if (total_n_applied > 0)
                  xml = xml + "<ManagementInfo><Operation>#{commercial_fertilizer_operation}</Operation><Year>#{application_date_year}</Year><Month>#{application_date_month}</Month><Day>#{application_date_day}</Day><Crop>#{crop_code}</Crop><FieldId>#{strip_id}</FieldId><OpVal1>1</OpVal1><OpVal2>#{total_n_applied.round(3)}</OpVal2><OpVal3>#{incorporation_depth.round(2)}</OpVal3><OpVal4>0</OpVal4><OpVal5>0</OpVal5><OpVal6>0</OpVal6><OpVal7>0</OpVal7><OpVal8>0</OpVal8><MID>#{mid}</MID></ManagementInfo>"
                end

                # for phosphorus
                if (total_p_applied > 0)
                  xml = xml + "<ManagementInfo><Operation>#{commercial_fertilizer_operation}</Operation><Year>#{application_date_year}</Year><Month>#{application_date_month}</Month><Day>#{application_date_day}</Day><Crop>#{crop_code}</Crop><FieldId>#{strip_id}</FieldId><OpVal1>2</OpVal1><OpVal2>#{total_p_applied.round(3)}</OpVal2><OpVal3>#{incorporation_depth.round(2)}</OpVal3><OpVal4>0</OpVal4><OpVal5>0</OpVal5><OpVal6>0</OpVal6><OpVal7>0</OpVal7><OpVal8>0</OpVal8><MID>#{mid}</MID></ManagementInfo>"
                end

                # if the incorporation date is different from the application date, add extra management info
                if commercial_fertilizer_application.is_incorporated && (commercial_fertilizer_application.application_date_year != commercial_fertilizer_application.incorporation_date_year || commercial_fertilizer_application.application_date_month != commercial_fertilizer_application.incorporation_date_month || commercial_fertilizer_application.application_date_day != commercial_fertilizer_application.incorporation_date_day)
                  operation_code = 250
                  incorporation_date_year = commercial_fertilizer_application.incorporation_date_year
                  incorporation_date_month = commercial_fertilizer_application.incorporation_date_month
                  incorporation_date_day = commercial_fertilizer_application.incorporation_date_day
                  xml = xml + "<ManagementInfo><Operation>#{operation_code}</Operation><Year>#{incorporation_date_year}</Year><Month>#{incorporation_date_month}</Month><Day>#{incorporation_date_day}</Day><Crop>#{crop_code}</Crop><FieldId>#{strip_id}</FieldId><OpVal1>0</OpVal1><OpVal2>0</OpVal2><OpVal3>0</OpVal3><OpVal4>0</OpVal4><OpVal5>0</OpVal5><OpVal6>0</OpVal6><OpVal7>0</OpVal7><OpVal8>0</OpVal8><MID>#{mid}</MID></ManagementInfo>"
                end

              end

              ########################################################
              # Other tillage operation
              ########################################################

              crop_rotation.tillage_operations.each do |tillage_operation|
                mid = mid + 1
                operation_code = tillage_operation.tillage_operation_type_id

                start_date_year = tillage_operation.start_date_year
                start_date_month = tillage_operation.start_date_month
                start_date_day = tillage_operation.start_date_day

                xml = xml + "<ManagementInfo><Operation>#{operation_code}</Operation><Year>#{start_date_year}</Year><Month>#{start_date_month}</Month><Day>#{start_date_day}</Day><Crop>#{crop_code}</Crop><FieldId>#{strip_id}</FieldId><OpVal1>0</OpVal1><OpVal2>0</OpVal2><OpVal3>0</OpVal3><OpVal4>0</OpVal4><OpVal5>0</OpVal5><OpVal6>0</OpVal6><OpVal7>0</OpVal7><OpVal8>0</OpVal8><MID>#{mid}</MID></ManagementInfo>"

              end

              ########################################################
              # end of season
              ########################################################
              crop_rotation.end_of_seasons.each do |end_of_season|

                mid = mid + 1

                operation_code = end_of_season.end_of_season_type_id
                opVal1 = end_of_season.is_harvest_as_silage ? 1 : 0

                year = end_of_season.year
                month = end_of_season.month
                day = end_of_season.day

                # if cover crop (only for crop)
                cover_crop = (field.field_type_id == 1 && crop_rotation.is_cover_crop) ? crop_rotation.cover_crop.code : 0
                planting_method = (field.field_type_id == 1 && crop_rotation.is_cover_crop) ? crop_rotation.planting_method_id : 0

                xml = xml + "<ManagementInfo><Operation>#{operation_code}</Operation><Year>#{year}</Year><Month>#{month}</Month><Day>#{day}</Day><Crop>#{crop_code}</Crop><FieldId>#{strip_id}</FieldId><OpVal1>#{opVal1}</OpVal1><OpVal2>0</OpVal2><OpVal3>0</OpVal3><OpVal4>0</OpVal4><OpVal5>0</OpVal5><OpVal6>#{cover_crop}</OpVal6><OpVal7>#{planting_method}</OpVal7><OpVal8>0</OpVal8><MID>#{mid}</MID></ManagementInfo>"

              end

              ########################################################
              # manure fertilizer application
              ########################################################
              crop_rotation.manure_fertilizer_applications.each do |manure_fertilizer_application|

                mid = mid + 1
                operation_code = manure_fertilizer_application.manure_consistency_id

                application_date_year = manure_fertilizer_application.application_date_year
                application_date_month = manure_fertilizer_application.application_date_month
                application_date_day = manure_fertilizer_application.application_date_day

                manure_application_code = '56'

                # if liquid and gallons
                conversion_rate = (operation_code == 265 && manure_fertilizer_application.liquid_unit_type_id == 1) ? (1000.0 * 8.34) : 2000

                application_rate = manure_fertilizer_application.application_rate.to_f * conversion_rate * ((100 - manure_fertilizer_application.moisture_content.to_f) / 100.0) * 1.121
                n_fraction = manure_fertilizer_application.total_n_concentration.to_f / conversion_rate / ((100 - manure_fertilizer_application.moisture_content.to_f) / 100.0)

                incorporation_depth = manure_fertilizer_application.is_incorporated ? (manure_fertilizer_application.incorporation_depth.to_f * 25.4) : 0

                # if total p
                if (manure_fertilizer_application.p_type_id == 1)
                  p_fraction = manure_fertilizer_application.p_concentration.to_f / conversion_rate / ((100 - manure_fertilizer_application.moisture_content.to_f) / 100.0)
                else # P205
                     # if liquid
                  lookup_p_fraction = (operation_code == 265 && manure_fertilizer_application.liquid_unit_type_id == 1) ? 0.5 : manure_fertilizer_application.manure_type.p_fraction.to_f
                  p_fraction = manure_fertilizer_application.p_concentration.to_f / lookup_p_fraction / conversion_rate / ((100 - manure_fertilizer_application.moisture_content.to_f) / 100.0)
                end

                # need to get the last 2 digits of the ID since they are shared by several animals
                manure_type_id = manure_fertilizer_application.manure_type_id.to_s[1..2]

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

                xml = xml + "<ManagementInfo><Operation>#{operation_code}</Operation><Year>#{application_date_year}</Year><Month>#{application_date_month}</Month><Day>#{application_date_day}</Day><Crop>#{crop_code}</Crop><FieldId>#{strip_id}</FieldId><OpVal1>#{manure_application_code}</OpVal1><OpVal2>#{application_rate}</OpVal2><OpVal3>#{incorporation_depth.round(2)}</OpVal3><OpVal4>#{n_fraction.round(4)}</OpVal4><OpVal5>#{manure_type_id}</OpVal5><OpVal6>0</OpVal6><OpVal7>#{p_fraction.round(4)}</OpVal7><OpVal8>#{manure_treatment}</OpVal8><MID>#{mid}</MID></ManagementInfo>"

                # if the incorporation date is different from the application date, add extra management info
                if manure_fertilizer_application.is_incorporated && (manure_fertilizer_application.application_date_year != manure_fertilizer_application.incorporation_date_year || manure_fertilizer_application.application_date_month != manure_fertilizer_application.incorporation_date_month || manure_fertilizer_application.application_date_day != manure_fertilizer_application.incorporation_date_day)
                  operation_code = 250
                  incorporation_date_year = manure_fertilizer_application.incorporation_date_year
                  incorporation_date_month = manure_fertilizer_application.incorporation_date_month
                  incorporation_date_day = manure_fertilizer_application.incorporation_date_day
                  xml = xml + "<ManagementInfo><Operation>#{operation_code}</Operation><Year>#{incorporation_date_year}</Year><Month>#{incorporation_date_month}</Month><Day>#{incorporation_date_day}</Day><Crop>#{crop_code}</Crop><FieldId>#{strip_id}</FieldId><OpVal1>0</OpVal1><OpVal2>0</OpVal2><OpVal3>0</OpVal3><OpVal4>0</OpVal4><OpVal5>0</OpVal5><OpVal6>0</OpVal6><OpVal7>0</OpVal7><OpVal8>0</OpVal8><MID>#{mid}</MID></ManagementInfo>"
                end
              end


            end
          end
        end
      end
      xml << "</Navigation>"

      return [true, xml]

    #rescue Exception =>
    #  return [false, ex]
    #end

  end
end