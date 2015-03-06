module Calculator

	def negative?
		if self < 0 
			true
		else 
			false
		end
	end

	def positive_or_zero
		if self.negative?
			return 0
		else
			return self
		end
	end

	def calculate_field_credits(total, total_future, delivery_factor)
		((total - total_future).positive_or_zero * delivery_factor).round
	end

	##### to eventually be pulled out into the Fields model #####


	def calculate_nitrogen_credits(field)

		def nitrogen_methods(field)
			return {:total => field.totals[:new_total_n], :total_future => field.totals[:new_total_n_future], :delivery_factor => field.watershed_segment.n_delivery_factor}
		end

		total = nitrogen_methods(field)[:total]
		total_future = nitrogen_methods(field)[:total_future]
		delivery_factor = nitrogen_methods(field)[:delivery_factor]
		return calculate_field_credits(total, total_future, delivery_factor)
	end

	def calculate_phosphorus_credits(field)

		def phosphorus_methods(field)
			return {:total => field.totals[:new_total_p], :total_future => field.totals[:new_total_p_future], :delivery_factor => field.watershed_segment.p_delivery_factor}
		end
		
		total = phosphorus_methods(field)[:total]
		total_future = phosphorus_methods(field)[:total_future]
		delivery_factor = phosphorus_methods(field)[:delivery_factor]
		return calculate_field_credits(total, total_future, delivery_factor)

	end

	def calculate_sediment_credits(field)

		def sediment_methods(field)
			return {:total => field.totals[:new_total_sediment], :total_future => field.totals[:new_total_sediment_future], :delivery_factor => field.watershed_segment.sediment_delivery_factor}
		end
		
		total = sediment_methods(field)[:total]
		total_future = sediment_methods(field)[:total_future]
		delivery_factor = sediment_methods(field)[:delivery_factor]
		return calculate_field_credits(total, total_future, delivery_factor)
		
	end

	def add_credits_for_each_field(fields)
		n_credits = 0
		p_credits = 0
		s_credits = 0
		fields.each do |f|
			n_credits += calculate_nitrogen_credits(f)
			p_credits += calculate_phosphorus_credits(f)
			s_credits += calculate_sediment_credits(f)
		end
		return {:n_credits => n_credits, :p_credits => p_credits, :s_credits => s_credits}
	end

end