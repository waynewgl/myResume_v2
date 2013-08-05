class User < ActiveRecord::Base

  belongs_to :skill

  has_and_belongs_to_many :articles

  attr_accessible :avatar
  attr_accessible :name
  attr_accessible :email
  attr_accessible :intro
  attr_accessible :skills
  attr_accessible :experience
  attr_accessible :referees
  attr_accessible :qalification
  attr_accessible :other_skills
  attr_accessible :developer_field
  attr_accessible :selected_style
  attr_accessible :phone
  attr_accessible :hobby


  acts_as_taggable
  acts_as_taggable_on :tag_list



  has_attached_file :avatar, :styles => { :small => "150x150>", :content => "800x800>", :thumb => "60x60>", :thumb_small=>"30x30>" },
                    :url => "/upload/paperclip/:class/user/:id/:style_:basename.:extension"  ,
                    :path => ":rails_root/public/upload/paperclip/:class/user/:id/:style_:basename.:extension"

end
