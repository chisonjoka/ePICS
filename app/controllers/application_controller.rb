class ApplicationController < ActionController::Base
  #protect_from_forgery
  before_filter :perform_basic_auth, :except => ['login','logout','authenticate',
    'store_room_printable','drug_availability_printable','monthly_report_printable',
    'daily_dispensation_printable','disposed_items_printable','expired_items_printable'
  ]

  protected                                                                     
                                                                                
  def perform_basic_auth
    if session[:user_id].blank?
      respond_to do |format|                                                    
        format.html { redirect_to :controller => 'user',:action => 'logout' }   
      end                                                                       
    elsif not session[:user_id].blank?
      User.current = User.find(session[:user_id])
    end                                                                         
  end 

end
