class AddAttachmentAttfileToAttachments < ActiveRecord::Migration
  def self.up
    change_table :attachments do |t|
      t.attachment :attfile
    end
  end

  def self.down
    drop_attached_file :attachments, :attfile
  end
end
