require 'spec_helper'

describe "Spree::Calculator::PostalService" do

	before(:each) do 
		@postal_service_calculator = Spree::Calculator::Shipping::PostalService.new
	end

	context ":using the default weight-price table: [1 2 5 10 20] => [6 9 12 15 18]" do
	  
		describe "#compute:" do


			it "gives 15.0 when total price is 100 and weight is 10kg" do
				create_our_package(:weight => 10.0, :price => 100.0, :quantity => 1)
				result = @postal_service_calculator.compute(@package)
				result.should eq(15.0)
			end		  

			it "gives 25.0 when total price is 40 and weight is 10kg" do
				create_our_package(:weight => 10.0, :price => 40.0, :quantity => 1)
				result = @postal_service_calculator.compute(@package)
				result.should eq(25.0)			  
			end

			it "gives 6 when total price is 60 and weight is less than 1kg" do
				create_our_package(:weight => 0.5, :price => 60.0, :quantity => 1)
				result = @postal_service_calculator.compute(@package)
				result.should eq(6.0)			  
			end

			it "gives 16 when total price is 40 and weight is less than 1kg" do
				create_our_package(:weight => 0.5, :price => 40.0, :quantity => 1)
				result = @postal_service_calculator.compute(@package)
				result.should eq(16.0)			  		  
			end
			  
			it "gives 30 when total price is 200 and weight is 25kg (split into two)" do
				create_our_package(:weight => 25.0, :price => 200.0, :quantity => 1)
				@postal_service_calculator.preferred_max_price = 250
				result = @postal_service_calculator.compute(@package)
				result.should eq(30.0)			  		  		  
			end

			it "gives 12 when total price is 100, there are three items and their weight is unknown" do
				order = FactoryGirl.create(:order)
				[30.0, 40.0, 30.0].each do |price|
					FactoryGirl.create(:line_item, 
						:price => price, 
						:quantity => 1, 
						:order => order,
						:variant => FactoryGirl.create(:base_variant, :weight => nil) )	    
				end
				order.line_items.reload		  
				shipment = FactoryGirl.create(:shipment, :order => order)
				package = shipment.to_package

				result = @postal_service_calculator.compute(shipment)
				result.should eq(12.0)			  		  		  
			end

			it "gives 0 when total price is more than the MAX, for any number of items " do
				create_our_package(:weight => 25.0, :price => 350.0, :quantity => 1)
				@postal_service_calculator.preferred_max_price = 300
				result = @postal_service_calculator.compute(@package)
				result.should eq(0.0)
			end
	  
		end

	end

	context "when preferred max weight, length and width are 18 kg, 120 cm and 60 cm" do
		describe "#available?" do

			it "is false when item weighs more than 18kg " do
			  create_our_package(:weight => 20, :height => 70, :width => 30, :depth => 30)
			  @postal_service_calculator.available?(@package.contents).should be_false
			end

			it "is false when item is longer than 120cm" do
			  create_our_package(:weight => 10, :height => 130, :width => 30, :depth => 30)
			  @postal_service_calculator.available?(@package.contents).should be_false			  
			end

			it "is false when item is wider than 60cm" do
			  create_our_package(:weight => 10, :height => 80, :width => 70, :depth => 30)
			  @postal_service_calculator.available?(@package.contents).should be_false			  			  
			end
			
		end

		describe "#item_oversized?" do
			
			it "is true if the longest side is more than 120cm" do
			  create_our_package(:weight => 10, :height => 130, :width => 40, :depth => 30)
			  @postal_service_calculator.item_oversized?(@variant).should be_true
			end

			it "is true if the second longest side is more than 60cm" do
			  create_our_package(:weight => 10, :height => 80, :width => 70, :depth => 30)
			  @postal_service_calculator.item_oversized?(@variant).should be_true				
			end

		end	  
	end

	def create_our_package(args={})
		params = {}
		params.merge!(:weight => args[:weight]) if args[:weight]
		params.merge!(:height => args[:height]) if args[:height]
		params.merge!(:width  => args[:width])  if args[:width]
		params.merge!(:depth  => args[:depth])  if args[:depth]
		@variant = FactoryGirl.create(:base_variant, params)

		params = {:variant => @variant}
		params.merge!(:price => args[:price])       if args[:price]
		params.merge!(:quantity => args[:quantity]) if args[:quantity]
		@line_item = FactoryGirl.create(:line_item, params)

		@order = @line_item.order
		@order.line_items.reload
		@shipment = FactoryGirl.create(:shipment, :order => @order)
		@package = @shipment.to_package			
	end


end
