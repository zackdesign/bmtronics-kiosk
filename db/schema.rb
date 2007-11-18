# This file is autogenerated. Instead of editing this file, please use the
# migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.

ActiveRecord::Schema.define(:version => 33) do

  create_table "accessories", :force => true do |t|
    t.column "name",         :string
    t.column "description",  :text
    t.column "price",        :decimal,  :precision => 9, :scale => 2, :default => 0.0,          :null => false
    t.column "created_at",   :datetime
    t.column "updated_at",   :datetime
    t.column "outofstock",   :boolean,                                :default => false
    t.column "discontinued", :boolean,                                :default => false
    t.column "picture_name", :string
    t.column "picture_type", :string,                                 :default => "image/jpeg"
    t.column "picture_data", :binary
    t.column "active",       :boolean,                                :default => true
    t.column "buy_price",    :decimal,  :precision => 9, :scale => 2
    t.column "supplier",     :text
    t.column "partnum",      :string
    t.column "corp_price",   :decimal,  :precision => 9, :scale => 2
  end

  create_table "charge_columns", :force => true do |t|
    t.column "charge_row_id", :integer,  :limit => 24
    t.column "name",          :text
    t.column "value",         :text
    t.column "created_at",    :datetime
    t.column "updated_at",    :datetime
  end

  create_table "charge_rows", :force => true do |t|
    t.column "charges_id", :integer,  :limit => 24
    t.column "name",       :text
    t.column "value",      :text
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  create_table "charges", :force => true do |t|
    t.column "name",         :string
    t.column "discontinued", :boolean,  :default => false
    t.column "description",  :text
    t.column "created_at",   :datetime
    t.column "updated_at",   :datetime
  end

  create_table "charges_plans", :id => false, :force => true do |t|
    t.column "charge_id", :integer, :null => false
    t.column "plan_id",   :integer, :null => false
  end

  add_index "charges_plans", ["charge_id", "plan_id"], :name => "index_charges_plans_on_charge_id_and_plan_id"

  create_table "features", :force => true do |t|
    t.column "name",        :string
    t.column "description", :text
    t.column "created_at",  :datetime
    t.column "updated_at",  :datetime
    t.column "active",      :boolean,  :default => true
  end

  create_table "options", :force => true do |t|
    t.column "name",        :text
    t.column "description", :text
    t.column "created_at",  :datetime
    t.column "updated_at",  :datetime
  end

  create_table "phones", :force => true do |t|
    t.column "name",          :string
    t.column "description",   :text
    t.column "outright",      :decimal,  :precision => 9, :scale => 2, :default => 0.0,          :null => false
    t.column "created_at",    :datetime
    t.column "updated_at",    :datetime
    t.column "outofstock",    :boolean,                                :default => false
    t.column "discontinued",  :boolean,                                :default => false
    t.column "picture_name",  :string
    t.column "picture_type",  :string,                                 :default => "image/jpeg"
    t.column "picture_data",  :binary
    t.column "buy_price",     :decimal,  :precision => 9, :scale => 2
    t.column "supplier",      :text
    t.column "partnum",       :string
    t.column "corp_price",    :decimal,  :precision => 9, :scale => 2
    t.column "gov_price",     :decimal,  :precision => 9, :scale => 2
    t.column "brand",         :text
    t.column "network",       :text
    t.column "prepaid",       :decimal,  :precision => 9, :scale => 2
    t.column "picture2_name", :string
    t.column "picture2_type", :string,                                 :default => "image/jpeg"
    t.column "picture2_data", :binary
    t.column "picture3_name", :string
    t.column "picture3_type", :string,                                 :default => "image/jpeg"
    t.column "picture3_data", :binary
  end

  create_table "phones_accessories", :id => false, :force => true do |t|
    t.column "phone_id",     :integer, :null => false
    t.column "accessory_id", :integer, :null => false
  end

  add_index "phones_accessories", ["phone_id", "accessory_id"], :name => "index_phones_accessories_on_phone_id_and_accessory_id"

  create_table "phones_features", :id => false, :force => true do |t|
    t.column "phone_id",   :integer, :null => false
    t.column "feature_id", :integer, :null => false
  end

  add_index "phones_features", ["phone_id", "feature_id"], :name => "index_phones_features_on_phone_id_and_feature_id"

  create_table "phones_plans", :force => true do |t|
    t.column "plan_id",      :integer, :limit => 24,                               :default => 0
    t.column "phone_id",     :integer, :limit => 24,                               :default => 0
    t.column "handset_cost", :decimal,               :precision => 9, :scale => 2
  end

  add_index "phones_plans", ["phone_id", "plan_id"], :name => "index_phones_plans_on_phone_id_and_plan_id"

# Could not dump table "plan_groups" because of following StandardError
#   Unknown type 'set('consumer','business','corporate','government')' for column 'categories'

# Could not dump table "plans" because of following StandardError
#   Unknown type 'set('consumer','business','corporate','government')' for column 'categories'

  create_table "plans_options", :id => false, :force => true do |t|
    t.column "plan_id",   :integer, :null => false
    t.column "option_id", :integer, :null => false
  end

  add_index "plans_options", ["plan_id", "option_id"], :name => "index_plans_options_on_plan_id_and_option_id"

end
