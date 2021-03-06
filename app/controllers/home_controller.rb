class HomeController < ApplicationController
  def index
    (session || {}).each do |name , values|
      next if name == 'location_name'
      next if name == 'location_id'
      next if name == 'user_id'
      next if name == 'flash'
      next if name == '_csrf_token'
      session[name] = nil
    end 

    @application = [
      ["Issue Items","orders/new","dispense.png"],
      ["Receive Items","stock/new","receive.png"],
      ["Exchange Items","epics_exchange/index","exchange_drugs1.png"],
      ["Lend Items","orders/lend","lend.png"],
      ["Borrow Items","stock/borrow","borrow.png"],
      ["Receive Items Back","/stock/receive_loan_returns","default.png"],
      ["Reimburse Borrowed Items","orders/return_loans","default.png"],
      ["Search","/product/search","search.png"]
    ]

    @reports = [
      ["Drug Availability","/report/select_store?report=drug_availability","available_drugs.png"],
      ["Daily Dispensation","/report/select_daily_dispensation_date","daily_dispense.png"],
      ["Central Hospital Monthly LMIS Report","/report/select_date_range","monthly_report.png"],
      ["Audit Report","/report/select_date_ranges?name=audit","audit_report.png"],
      ["View Received/Issued","/report/select_date_ranges?name=received_items","view_issued_received.png"],
      ["View Store Room","/report/select_store","first_aid_kit_icon.png"],
      ["View expired items","report/expired_items","expired.jpeg"],
      ["View Disposed items","/report/select_date_ranges","disposal.png"],
      ["View alerts","/report/view_alerts","alert_list.png"]
    ]

    @activities = []

    @administration = [
      ["Set Items","/product/index","default.png"],
      ["Print Location","/location/print_location_menu","emblem_print.png"],
      ["Set Contacts","/contact/index","default.png"]
    ]

    if User.current.epics_user_role.name == "Administrator"
      @administration << ["Set Item Units","/product_units/index","units_icon.png"] << ["Set Item Types","/product_type/index","set_items.png"]
      @administration << ["Set Item Categories","/product_category/index","Item_categories.png"] << ["Set Order Types","/order_type/index","order_type.png"]
      @administration << ["Set Supplier Types","/supplier_type/index","supplier_type.png"] << ["Set Suppliers","/supplier/index","suppliers.png"]
      @administration << ["Set Locations","/location/index","sysuser.png"] << ["Set Location Types","/location_type/index","workstations.png"]
      @administration << ["Add New User","/user/new","add_user.png"]

      #<< ["Add person","person/add_person","add_user.png"]

    end

    @buttons_count = @application.length
    @buttons_count = @reports.length if @reports.length > @buttons_count
    @buttons_count = @activities.length if @activities.length > @buttons_count
    @buttons_count = @administration.length if @administration.length > @buttons_count

    @reminders = EpicsLendBorrowAuthorizer.find(:all, :conditions => ["voided = ? AND authorized = ?",false,false]).length rescue 0

    ############################ alerts ######################################
    if params[:show_alerts_popup] == 'true'
      @alerts = EpicsReport.alerts
    else
      @alerts = []
    end
    ################################ end #####################################

    render :layout => false
  end

end
