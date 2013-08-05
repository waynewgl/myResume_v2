class ApplicationController < ActionController::Base
  #protect_from_forgery

  before_filter :set_locale

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end


  def tag_cloud
    @tags = Article.tag_counts_on(:tags)
  end

end
