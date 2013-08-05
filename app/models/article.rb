class Article < ActiveRecord::Base

  belongs_to :user
  has_and_belongs_to_many :attachments

  attr_accessible :content, :title, :tag

  acts_as_taggable
  acts_as_taggable_on :tag_list


  acts_as_votable


  acts_as_commentable

end
