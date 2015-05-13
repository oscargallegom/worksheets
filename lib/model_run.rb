module ModelRun

    def model_run(field)


      success, content = callNtt(field, false)

      logger.debug "%%%%%%%%%%%%%%%%%%%%%% content: #{content}"

        if success
          @ntt_results = Hash.from_xml(content.xpath('//Results').to_s)['Results']
          if (@ntt_results['ErrorCode'] != '0')
            field.ntt_xml_current = nil
            ENV['debug'] += 'Error retrieving current<br/>'
            raise 'Could not retrieve NTT data.'
          else
            field.ntt_xml_current = content.to_s
            field.save
          end
        else
          field.ntt_xml_current = nil
          ENV['debug'] += 'Error retriebing current<br/>'
          #self[:ntt_call_status] += 'Could not retrieve NTT data:' + content.to_s
          raise 'Could not retrieve NTT data: ' + content.to_s
        end

    end

    def model_run_future(field)


      success, content = callNtt(field, true)

              if (success)
                @ntt_results = Hash.from_xml(content.xpath('//Results').to_s)['Results']
                if (@ntt_results['ErrorCode'] != '0')
                  field.ntt_xml_future = nil
                  #raise 'Could not retrieve NTT data for future scenario.'
                  self[:ntt_call_status] += 'Could not retrieve NTT data for future scenario.'
                  ENV['debug'] += 'Error retrieving future<br/>'
                else
                  field.ntt_xml_future = content.to_s
                end
              else
                field.ntt_xml_future = nil
                ENV['debug'] += '<br/>Error retrieving future<br/>'
                self[:ntt_call_status] += 'Could not retrieve NTT data for future scenario: ' + content.to_s
                #raise 'Could not retrieve NTT data for future scenario: ' + content.to_s
              end

    end

    future_sediment_with_conversion = 0
    future_sediment_without_conversion = 0


    def calculate_bmps(field)
        @with_conversion = Hash.new
        @current_totals = computeBmpCalculations(field)
        @ntt_results = @current_totals[:ntt_results]
        @ntt_results_future = @current_totals[:ntt_results_future]

        if (@ntt_results.any?)
            @current_total_n = ((@ntt_results['OrganicN'].to_f + @ntt_results['NO3'].to_f + @ntt_results['TileDrainN'].to_f) if (@ntt_results.key?('OrganicN') && @ntt_results.key?('NO3') && @ntt_results.key?('TileDrainN'))).round(2)
            @current_sediment_organic_n = (@ntt_results['OrganicN'].to_f if @ntt_results.key?('OrganicN')).round(2)
            @current_soluble_n = (@ntt_results['NO3'].to_f).round(2)
            @tile_drained_n = (@ntt_results['TileDrainN'].to_f).round(2)
            @current_total_p = ((@ntt_results['OrganicP'].to_f + @ntt_results['SolubleP'].to_f + @ntt_results['TileDrainP'].to_f)).round(2)
            @current_sediment_organic_p = (@ntt_results['OrganicP'].to_f).round(2)
            @current_soluble_p = (@ntt_results['SolubleP'].to_f).round(2)
            @current_flow = (@ntt_results['Flow'].to_f).round(2)
            @current_sediment = (@ntt_results['Sediment'].to_f).round(2)
            @current_carbon = (@ntt_results['Carbon'].to_f).round(2)

        end

        if (!@ntt_results_future.nil?)
          @future_total_n = ((@ntt_results_future['OrganicN'].to_f + @ntt_results_future['NO3'].to_f + @ntt_results_future['TileDrainN'].to_f) if (@ntt_results_future.key?('OrganicN') && @ntt_results_future.key?('NO3') && @ntt_results_future.key?('TileDrainN'))).round(2)

          @future_sediment_organic_n = (@ntt_results_future['OrganicN'].to_f if @ntt_results_future.key?('OrganicN')).round(2)

          @future_soluble_n = (@ntt_results_future['NO3'].to_f).round(2)

          @future_tile_drained_n = (@ntt_results_future['TileDrainN'].to_f).round(2)

          @future_total_p = ((@ntt_results_future['OrganicP'].to_f + @ntt_results_future['SolubleP'].to_f + @ntt_results_future['TileDrainP'].to_f)).round(2)

          @future_sediment_organic_p = (@ntt_results_future['OrganicP'].to_f).round(2)

          @future_soluble_p = (@ntt_results_future['SolubleP'].to_f).round(2)

          @future_tile_drained_p = (@ntt_results_future['TileDrainP'].to_f).round(2)

          @future_flow = (@ntt_results_future['Flow'].to_f).round(2)

          @future_sediment = (@ntt_results_future['Sediment'].to_f).round(2)

          @future_carbon = (@ntt_results_future['Carbon'].to_f).round(2)
        end

        # field.current_total_n = @current_total_n
        # field.current_sediment_organic_n = @current_sediment_organic_n
        # field.current_soluble_n = @current_soluble_n
        # field.tile_drained_n = @tile_drained_n
        # field.current_total_p = @current_total_p
        # field.current_sediment_organic_p = @current_sediment_organic_p
        # field.current_soluble_p = @current_soluble_p
        # #field.current_flow = @current_flow
        # field.current_sediment = @current_sediment
        # field.current_carbon = @current_carbon
        # field.future_total_n = @future_total_n
        # field.future_sediment_organic_n = @future_sediment_organic_n
        # field.future_soluble_n = @future_soluble_n
        # field.future_tile_drained_n = @future_tile_drained_n
        # field.future_total_p = @future_total_p
        # field.future_sediment_organic_p = @future_sediment_organic_p
        # field.future_soluble_p = @future_soluble_p
        # field.future_flow = @future_flow
        # field.future_sediment = @future_sediment
        # field.future_carbon = @future_carbon
        field.save

        @with_conversion[:sediment] = @current_totals[:new_total_sediment_future]
        @with_conversion[:nitrogen] = @current_totals[:new_total_n_future]
        @with_conversion[:phosphorus] = @current_totals[:new_total_p_future]
        return @with_conversion
    end



        def calculate_bmps_without_conversion(field)
          
        @without_conversion = Hash.new
        @current_totals = computeBmpCalculationsWithoutConversion(field)
        @ntt_results = @current_totals[:ntt_results]
        @ntt_results_future = @current_totals[:ntt_results_future]

        if (@ntt_results.any?)
            @current_total_n = ((@ntt_results['OrganicN'].to_f + @ntt_results['NO3'].to_f + @ntt_results['TileDrainN'].to_f) if (@ntt_results.key?('OrganicN') && @ntt_results.key?('NO3') && @ntt_results.key?('TileDrainN'))).round(2)
            @current_sediment_organic_n = (@ntt_results['OrganicN'].to_f if @ntt_results.key?('OrganicN')).round(2)
            @current_soluble_n = (@ntt_results['NO3'].to_f).round(2)
            @tile_drained_n = (@ntt_results['TileDrainN'].to_f).round(2)
            @current_total_p = ((@ntt_results['OrganicP'].to_f + @ntt_results['SolubleP'].to_f + @ntt_results['TileDrainP'].to_f)).round(2)
            @current_sediment_organic_p = (@ntt_results['OrganicP'].to_f).round(2)
            @current_soluble_p = (@ntt_results['SolubleP'].to_f).round(2)
            @current_flow = (@ntt_results['Flow'].to_f).round(2)
            @current_sediment = (@ntt_results['Sediment'].to_f).round(2)
            @current_carbon = (@ntt_results['Carbon'].to_f).round(2)

        end

        if (!@ntt_results_future.nil?)
          @future_total_n = ((@ntt_results_future['OrganicN'].to_f + @ntt_results_future['NO3'].to_f + @ntt_results_future['TileDrainN'].to_f) if (@ntt_results_future.key?('OrganicN') && @ntt_results_future.key?('NO3') && @ntt_results_future.key?('TileDrainN'))).round(2)

          @future_sediment_organic_n = (@ntt_results_future['OrganicN'].to_f if @ntt_results_future.key?('OrganicN')).round(2)

          @future_soluble_n = (@ntt_results_future['NO3'].to_f).round(2)

          @future_tile_drained_n = (@ntt_results_future['TileDrainN'].to_f).round(2)

          @future_total_p = ((@ntt_results_future['OrganicP'].to_f + @ntt_results_future['SolubleP'].to_f + @ntt_results_future['TileDrainP'].to_f)).round(2)

          @future_sediment_organic_p = (@ntt_results_future['OrganicP'].to_f).round(2)

          @future_soluble_p = (@ntt_results_future['SolubleP'].to_f).round(2)

          @future_tile_drained_p = (@ntt_results_future['TileDrainP'].to_f).round(2)

          @future_flow = (@ntt_results_future['Flow'].to_f).round(2)

          @future_sediment = (@ntt_results_future['Sediment'].to_f).round(2)

          @future_carbon = (@ntt_results_future['Carbon'].to_f).round(2)
        end

        # field.current_total_n = @current_total_n
        # field.current_sediment_organic_n = @current_sediment_organic_n
        # field.current_soluble_n = @current_soluble_n
        # field.tile_drained_n = @tile_drained_n
        # field.current_total_p = @current_total_p
        # field.current_sediment_organic_p = @current_sediment_organic_p
        # field.current_soluble_p = @current_soluble_p
        # field.current_flow = @current_flow
        # field.current_sediment = @current_sediment
        # field.current_carbon = @current_carbon
        # field.future_total_n = @future_total_n
        # field.future_sediment_organic_n = @future_sediment_organic_n
        # field.future_soluble_n = @future_soluble_n
        # field.future_tile_drained_n = @future_tile_drained_n
        # field.future_total_p = @future_total_p
        # field.future_sediment_organic_p = @future_sediment_organic_p
        # field.future_soluble_p = @future_soluble_p
        # field.future_flow = @future_flow
        # field.future_sediment = @future_sediment
        # field.future_carbon = @future_carbon
        field.save


                @without_conversion[:sediment] = @current_totals[:new_total_sediment_future]
                @without_conversion[:nitrogen] = @current_totals[:new_total_n_future]
                @without_conversion[:phosphorus] = @current_totals[:new_total_p_future]
                return @without_conversion
    end


end