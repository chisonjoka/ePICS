class HomeController < ApplicationController
  def index
    @application = [
      ["Items","z","default.png"],
      ["Dispense","z","default.png"],
      ["View alerts","z","default.png"]
    ]

    @reports = []
    @activities = []
    @administration = [
      ["Add Item Units","/product_units/index","default.png"],
      ["Add Item Types","/product_type/index","default.png"],
      ["Add Item Category","/product_category/index","default.png"],
      ["Add Item","/product/index","default.png"],
      ["Add Supplier Type","/supplier_type/index","default.png"],
      ["Add Supplier","/supplier/index","default.png"],
      ["Add Order Type","/order_type/index","default.png"],
      ["Add Location Type","/location_type/index","default.png"],
      ["Add Location","/location/index","default.png"],
    ]

    render :layout => false
    
  end

end
