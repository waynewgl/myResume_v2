class CreateArticlesAttachments < ActiveRecord::Migration
  def change
    create_table :articles_attachments do |t|
      t.integer :article_id
      t.integer :attachment_id

      t.timestamps
    end
  end
end
