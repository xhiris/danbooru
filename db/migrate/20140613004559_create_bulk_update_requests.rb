class CreateBulkUpdateRequests < ActiveRecord::Migration
  def change
    create_table :bulk_update_requests do |t|
      t.integer :user_id
      t.integer :forum_topic_id
      t.text :script
      t.string :status

      t.timestamps
    end
  end
end
