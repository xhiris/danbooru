class BulkUpdateRequest < ActiveRecord::Base
  belongs_to :user
  belongs_to :forum_topic

  validates_presence_of :forum_topic, :user
  validates_inclusion_of :status, :in => %w(pending approved rejected)
  attr_accessible :user_id, :forum_topic_id
  attr_accessible :status, :as => [:admin]

  def approve!
    AliasAndImplicationImporter.new(script, forum_topic_id, "1").process!
  end
end
