require 'mime/types'

class Attachment < ActiveRecord::Base

  belongs_to :article

  attr_accessible :title
  attr_accessible :attfile
  attr_accessible :attfile_file_name

  has_attached_file :attfile, :styles => { :small => "150x150>", :content => "800x800>", :thumb => "60x60>" },
                    :url => "/upload/paperclip/:class/:attachment/:id/:style_:basename.:extension"  ,
                    :path => ":rails_root/public/upload/paperclip/:class/:attachment/:id/:style_:basename.:extension"

  validates_attachment_presence :attfile
  validates_attachment_size :attfile, :less_than => 5.megabytes


  before_attfile_post_process :prevent_pdf_thumbnail

  def prevent_pdf_thumbnail
    #return false if attfile_file_name.index(".pdf")
    return false if attfile_content_type.index("image").nil?
    #return false if (data_content_type =~ /application\/.*pdf/)

  end

  def pdf_attached?
    return true if attfile_content_type.index("image").nil?
  end





end
