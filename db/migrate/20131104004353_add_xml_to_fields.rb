class AddXmlToFields < ActiveRecord::Migration
  def change
    add_column :fields, :ntt_xml_current, :text
    add_column :fields, :ntt_xml_future,  :text
  end
end
