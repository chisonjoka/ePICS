class EpicsOrderTypes < ActiveRecord::Base
	set_table_name :epics_order_types 
	set_primary_key :epics_order_type_id
  default_scope where('voided = 0')
  has_many :epics_orders, :foreign_key => :epics_order_type_id, :conditions => {:voided => 0}

  include Epics

end
