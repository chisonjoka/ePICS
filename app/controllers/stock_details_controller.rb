class StockDetailsController < ApplicationController


  def index
    @cart = find_product_cart
    render :layout => "custom"
  end

  def new
    unless session[:stock].nil?
      @stock_detail = EpicsStockDetails.new()
      @locations_map = EpicsLocation.find(:all, :conditions => ["epics_location_type_id = ? ",
                                                   EpicsLocationType.find_by_name("Store room").id ]).map{|location| [location.name,location.epics_location_id]}
      @product_category_map = EpicsProductCategory.all.map{|category| [category.name, category.epics_product_category_id]}
      @product_expire_details = {}
      epics_products = EpicsProduct.all
      epics_products.map{|product| @product_expire_details[product.name] = product.expire }
    end
  end

  def create
    @cart = find_product_cart
    product = EpicsProduct.find_by_name(params[:stock_details][:product_name])
    quantity = params[:stock_details][:quantity].to_f
    location = params[:stock_details][:location_id]
    expiry_date = params[:stock_details][:expiry_date]
    @cart.add_product(product,quantity,location,expiry_date)

    redirect_to :action => :index
  end

  def edit
  end

  def update
  end

  def void
  end

  def checkout

    type = ActiveSupport::JSON.decode params[:type] rescue nil
    if params[:type].blank?
      stock = session[:stock]
      stock_details = find_product_cart
    elsif type == 'borrow'
      stock = session[:borrow]
      stock_details = (session[:borrow_cart] ||= ProductCart.new)
    end

    unless stock.nil?
      unless stock_details.nil?
        EpicsStock.transaction do
          
          @stock = EpicsStock.new()
          @stock.grn_date = stock[:grn_date]
          @stock.grn_number = stock[:grn_number]
          @stock.epics_supplier_id = stock[:supplier_id]
          @stock.save!

          fname = stock[:witness_names].split(" ")[0].squish!
          lname = stock[:witness_names].split(" ")[1].squish!
          person = EpicsPerson.where("fname = ? AND lname = ?",fname,lname ).first.id

          @witness = EpicsStockWitness.new
          @witness.epics_stock_id = @stock.epics_stock_id
          @witness.epics_person_id = person
          @witness.save!



          if type.eql?('borrow')

            lend = EpicsLendsOrBorrows.new
            lend.epics_stock_id = @stock.id
            lend.facility = EpicsLocation.find_by_name(stock[:borrowing_from]).id
            lend.lend_or_borrow_date = stock[:grn_date]
            lend.epics_lends_or_borrows_type_id = EpicsLendsOrBorrowsType.find_by_name("borrow").id
            lend.return_date = stock[:return_date]
            lend.save

            authorizer = EpicsLendBorrowAuthorizer.new
            authorizer.epics_person_id = stock[:authorizer]
            authorizer.epics_lends_or_borrows_id = lend.id
            authorizer.save

          end

          for item in stock_details.items
            @stock_detail = EpicsStockDetails.new()
            @stock_detail.epics_stock_id = @stock.epics_stock_id
            @stock_detail.epics_products_id = item.product_id
            @stock_detail.epics_location_id = item.location
            @stock_detail.received_quantity = item.quantity
            @stock_detail.current_quantity = item.quantity
            @stock_detail.epics_product_units_id = item.product.epics_product_units_id
            @stock_detail.save!

            unless item.expiry_date.blank?
              @stock_expiry_dates = EpicsStockExpiryDates.new()
              @stock_expiry_dates.epics_stock_details_id = @stock_detail.epics_stock_details_id
              @stock_expiry_dates.expiry_date = item.expiry_date
              @stock_expiry_dates.save!
            end
          end

          if type.eql?('borrow')
            session[:borrow] = session[:borrow_cart] = nil
          else
            session[:cart] = session[:stock] = nil
          end
          redirect_to :action => :summary, :stock_id => @stock.epics_stock_id
        end
      end
    end
    
  end

  def borrow
    @locations_map = EpicsLocation.find(:all, :conditions => ["epics_location_type_id = ? ",
                                                              EpicsLocationType.find_by_name("Store room").id ]).map{|location| [location.name,location.epics_location_id]}
    @product_category_map = EpicsProductCategory.all.map{|category| [category.name, category.epics_product_category_id]}
    @product_expire_details = {}
    epics_products = EpicsProduct.all
    epics_products.map{|product| @product_expire_details[product.name] = product.expire }

    if request.post?
      @borrow_cart =  (session[:borrow_cart] ||= ProductCart.new)
      product = EpicsProduct.find_by_name(params[:stock_details][:product_name])
      quantity = params[:stock_details][:quantity].to_f
      location = params[:stock_details][:location_id]
      expiry_date = params[:stock_details][:expiry_date]
      @borrow_cart.add_product(product,quantity,location,expiry_date)

      redirect_to "/stock/borrow_index"
    end

  end

  def summary
    @stock = EpicsStock.find(params[:stock_id])
    @stock_details = EpicsStockDetails.find_all_by_epics_stock_id(params[:stock_id])
    render :layout => "custom"
  end

  def remove_product_from_cart
    product_id = params[:product_id]
    product = EpicsProduct.find(product_id)
    cart = session[:cart]
    cart.remove_product(product)
    render :text => "true"
  end


  protected
  
  def find_product_cart
    session[:cart] ||= ProductCart.new
  end

end
