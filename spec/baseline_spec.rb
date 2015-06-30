require "rails_helper"
require "baseline_check"

describe Field do
	include BaselineCheck

  	describe '#checkBaseline' do

  		field = Field.new
		strip = Strip.new
		field.strips << strip
		crop_rotation = CropRotation.new
		strip.crop_rotations << crop_rotation
		fert = ManureFertilizerApplication.new
		crop_rotation.manure_fertilizer_applications << fert
		fert.is_incorporated = false

	    it "returns true if HEL soils and fertilizer NOT incorporated" do
	  		field.hel_soils = true
	  		assert_equal checkBaseline(field), true
	  	end

	  	it "returns false if HEL soils and fertilizer NOT incorporated" do
	  		field.hel_soils = false
	  		assert_equal checkBaseline(field), false
	  	end

  end

end