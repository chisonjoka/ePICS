class HomeController < ApplicationController
  def index
    @application = [
      ["Issue Items","orders/new","dispense.png"],
      ["Receive Items","stock/new","receive.png"],
      ["Exchange Items","epics_exchange/index","exchange_drugs1.png"],
      ["Lend Items","orders/lend","lend.png"],
      ["Search","/product/search","search.png"]
    ]

    @reports = [
      ["Drug Availability","/report/drug_availability","available_drugs.png"],
      ["Daily Dispensation","/report/daily_dispensation","daily_dispense.png"],
      ["Central Hospital Monthly LMIS Report","/report/monthly_report","monthly_report.png"],
      ["Audit Report","/report/audit_report","audit_report.png"],
      ["View Received/Issued","/report/received_items","view_issued_received.png"],
      ["View Store Room","/report/store_room","first_aid_kit_icon.png"],
      ["View alerts","/report/view_alerts","alert_list.png"]
    ]
    @activities = []
    @administration = [
      ["Set Item Units","/product_units/index","default.png"],
      ["Set Item Types","/product_type/index","default.png"],
      ["Set Item Categories","/product_category/index","default.png"],
      ["Set Items","/product/index","default.png"],
      ["Set Supplier Types","/supplier_type/index","default.png"],
      ["Set Suppliers","/supplier/index","default.png"],
      ["Set Order Types","/order_type/index","default.png"],
      ["Set Location Types","/location_type/index","default.png"],
      ["Set Locations","/location/index","default.png"],
      ["Add person","person/add_person","add_user.png"],
    ]

    @buttons_count = @application.length
    @buttons_count = @reports.length if @reports.length > @buttons_count
    @buttons_count = @activities.length if @activities.length > @buttons_count
    @buttons_count = @administration.length if @administration.length > @buttons_count

    render :layout => false
    
  end

end
