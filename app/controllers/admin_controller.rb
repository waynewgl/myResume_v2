class AdminController < ApplicationController

  include ActionView::Helpers::SanitizeHelper



  def index



  end

  def  delete_article

    logger.info "now we got article id #{params[:article_id]}"


    if !params[:article_id].nil?


      art_id = params[:article_id].to_i

      deleted_article= Article.where("id = ?",art_id).first


        deleteAttachments = deleted_article.attachments.all


        if !deleteAttachments.nil?

           for de_attachment in  deleteAttachments

             de_attachment.update_attribute(:attfile,nil)

           end
        end

        deleted_article_attachment= ArticlesAttachment.delete_all(["article_id = ?", art_id])


        deleted_article =Article.delete(["id = ?",art_id])


        delete_comments= Comment.delete_all(["commentable_id = ?", art_id])


        delete_user_article= ArticlesUsers.delete_all(["article_id = ?",art_id])



      if  deleted_article>0 and deleted_article_attachment>=0  and delete_comments>=0  and delete_user_article>=0

          render :inline =>  "OK"

        else
          render :inline =>  "Article cannot be deleted.."

        end


    end

  end


  def myArticle_detail


    if !session[:user_login_id].nil?

      @article_detail_info =   Article.where("id=?",params[:article_info]).first

      @comments = @article_detail_info.comments.order("created_at asc").paginate(:page => params[:page], :per_page => 8)


      user= User.find_by_sql "select * from users u where u.id = (select a.user_id from articles_users a where a.article_id = #{@article_detail_info.id} limit 1)"

      @article_author =user[0]
      @article_author_avatar=nil

      if !@article_author.nil? && @article_author.avatar_file_name!=""


        @article_author_avatar= @article_author.avatar.url(:thumb_small)

      end

      #render :json => @article_author

     else

       redirect_to :controller => :site, :action => :index

     end

  end

  def returnArticleContent


      logger.info "article id received.....#{params[:article_id]}"


      article=Article.where('id=?',params[:article_id]).first

      plain_text = strip_tags(article.content)


      render :inline =>  plain_text


  end



  def update_article_content

      if params[:edit_title]=="true"

        article=Article.where('id=?',params[:article_id]).first

        if article.update_attribute(:title, params[:value])
          render :inline =>  article.title
        else

          render :inline =>  "Article cannot be updated"

        end

      else

        article=Article.where('id=?',params[:article_id]).first

        if article.update_attribute(:content, params[:article_content])
          render :inline =>  "Article is updated"
        else

          render :inline =>  "Article cannot be updated"

        end

      end


  end

  def load_atts_for_profile

    @user_avatar = nil

    if (!params[:user_id].nil? && params[:user_id].to_i > 0)

      @user_avatar = User.where(:id => params[:user_id]).first

    end

    render :partial => 'partials/admin/profile_atts_preview'


  end


  def edit_profile_others


    h=Hash.new


    user_id=session[:user_login_id]

    skills_selected=""

    @user_update =User.where("id=?",user_id ).first



      @user_update.update_attributes(params[:edit_profile_others])


      if  !params[:edit_profile_others][:skills].nil?

          for skill in params[:edit_profile_others][:skills]


            skills_selected = skills_selected + skill+","

          end

          @user_update.update_attributes(:skills=>skills_selected )

          @user_update.tag_list=params[:edit_profile_others][:skills]


          @user_update.save
      else

          @user_update.skills = ""

      end

      session[:user_account_name]= @user_update.name

      logger.info "now we have got profile skills  #{skills_selected}"

      h[:message] = "user detail is updated"
      render :inline => h.to_json
      return

  end



  def edit_profile





    h=Hash.new


    @available_skills=["IPhone","Objective C","Android","Java","J2EE(Spring)", "J2EE(Structs)",  "WinPhone","C#", "C++","Ruby","Ruby On Rails","Asp.net","VB.net","Perl","PHP","PHP(WordPress)","JQUERY", "Javascript","Oracle","MYSQL"]

    user_id=session[:user_login_id]


    @user_avatar_ori =User.where("id=?",user_id ).first


    selected_skills =nil
    @selected_force =nil


    if !@user_avatar_ori.skills.nil?


      selected_skills = @user_avatar_ori.skills


      @selected_force = selected_skills.split(",")

      @selected_force =  @selected_force.delete_if{ |x| x.empty? }

    end




    if !params[:edit_true].nil? &&!params[:edit_profile].blank?


      @user_avatar_ori.update_attributes(params[:edit_profile])

      if !@user_avatar_ori.nil?
        h[:user_id]=user_id
      end

      h[:message] = "avatar is created"
      render :inline => h.to_json
      return

    end




  end





  def register_form




  end

  def create_article




    logger.info " article title name  #{params['article_title']}   article tag  #{params['article_tag']}  with  article tag  #{params['article_content']}"

    if params['article_title'].blank? || params['article_tag'].blank? || params['article_content'].blank?

      render :inline => 'please input all required fields'

    else

      if params[:article_id].to_i == 0

       article=Article.new
       article.title= params['article_title']
       article.content= params['article_content']

       article.tag=params['article_tag'].to_s

       article.tag_list= params['article_tag'].to_s

       article.save

       usersArticle=ArticlesUsers.new
       usersArticle.user_id=session[:user_login_id]
       usersArticle.article_id= article.id
       usersArticle.save

       render :inline => 'Article is created'

      else

        article=Article.where('id=?',params[:article_id]).first
        article.title= params['article_title']
        article.content= params['article_content']

        article.tag=params['article_tag'].to_s

        article.tag_list= params['article_tag'].to_s


        article.save

        usersArticle=ArticlesUsers.new
        usersArticle.user_id=session[:user_login_id]
        usersArticle.article_id= article.id
        usersArticle.save

        render :inline => 'Article is created with image attached'

      end

    end



  end

  def load_atts_for_article

    @images = nil
    @files = nil
    @article_id = nil

    if (!params[:article_id].nil? && params[:article_id].to_i > 0)

      article = Article.where(:id => params[:article_id]).first

      if !article.nil?
        @article_id = article.id

        #@images = article.redactor_rails_assets.where(:type => t('assets.image-type'))

        @images = article.attachments.where("attfile_content_type like ?","image%")
        @files = article.attachments.where("attfile_content_type not like ?","image%")
      end


    end

    #render :js => 'admin/articles_load_images.js'
    render :partial => 'partials/admin/articles_atts_preview'


  end



  def add_attachment

    h=Hash.new

    logger.info " and article id #{params[:article_id]}    now we got attachment attribute #{params[:attachment]}  "


    if params[:article_id].blank? || params[:article_id].to_i == 0

      article_id = new_article
    else
      article_id = params[:article_id].to_i

    end


    if !params[:attachment].blank?
      attachment = Attachment.new params[:attachment]
      if attachment.save

        if !create_attachment_reference(article_id,attachment.id)
          h[:message] = "Error: Attachment couldn't be saved."
          render :inline => h.to_json
          return
        end


        h[:article_id] = article_id
        h[:message] = "attachment is created"
        render :inline => h.to_json
        return
      else

        h[:message] = "Error: Attachment couldn't be saved."
        render :inline => h.to_json
        return
      end

    else
      h[:message] = "Error: Attachment couldn't be saved."
      render :inline => h.to_json
      return

   end
  end


  def create_attachment_reference(article_id,attachment_id)

    if (!article_id.nil? && article_id > 0 && !attachment_id.nil?)


      aa = ArticlesAttachment.new
      aa.article_id = article_id
      aa.attachment_id = attachment_id
      if aa.save
        #render :inline => "ERR: Could not save new reference"
        return true
      else
        #render :inline => "Image attached."
        return false
      end
    else
      #render :inline => "ERR: Could not save new reference"
      return false
    end

  end

  def detach_attachment

    att_id = nil

    if (!params[:article_id].blank? && !params[:att_id].blank?)

      if !params[:id_string].blank?
        att_id = params[:att_id].gsub(params[:id_string],'').to_i
      else
        att_id = params[:att_id].to_i
      end

      #deleted_rows = ArticleAsset.delete_all(["article_id = ? and asset_id = ?", params[:article_id].to_i, params[:image_id].to_i])
      deleted_rows = ArticlesAttachment.delete_all(["article_id = ? and attachment_id = ?", params[:article_id].to_i, att_id])

      deleted_att_before = Attachment.where("id = ?", att_id).first

      deleted_att_before.update_attribute(:attfile, nil)

      deleted_att = Attachment.delete_all(["id = ?", att_id])



      if deleted_rows > 0 and deleted_att>0
        render :inline => "OK"
        return
      else
        render :inline => "Error: Could not detach image"
        return
      end
    else
      render :inline => "Error: Could not detach image"
      return
    end


  end





  def new_article

    @new_article = nil

    @new_article = Article.new
    h = Hash.new

    if !@new_article.save
      logger.info "Error: Could not save new article in admin/new_article"
      h[:id] = 0
      #render :inline => h.to_json
      return 0
    else
      h[:id] = @new_article.id
      #render :inline => h.to_json
      return @new_article.id
    end

  end


  def sign_in


    logger.info " login name  #{params['user_account_login']}   password  #{params['user_account_password']} "


    if params['user_account_login'].blank? || params['user_account_password'].blank?
      render :inline => 'please input all required fields'
      return
    else
      user = User.where("login = ? and password = ?", params['user_account_login'], Digest::SHA1.hexdigest(params['user_account_password'])).first

      if user.nil?
        render :inline => 'User account does not exist..wrong account name or password'
        return
      else
        session[:user_login]= user.login
        session[:user_account_name]= user.name
        session[:user_login_id]= user.id
        render :inline => 'loginOK'
        return
      end
    end

  end



  def myProject

      if session[:user_login].nil?

         redirect_to :controller => :site, :action => :index

      else

        if  !session[:user_account_name].nil? &&  !session[:user_account_name].blank?

          @user_sign_name= session[:user_account_name].slice(0,1).capitalize + session[:user_account_name].slice(1..-1)

        end


        user = User.where("id=?",session[:user_login_id]).first

        @user_logged=user



        @user_articles =nil


        if !params[:tag].nil?  &&   params[:all]!="true"

          @user_articles = user.articles.tagged_with(params[:tag]).paginate(:page => params[:page], :per_page => 6).order("created_at desc")


        else

          @user_articles = user.articles.paginate(:page => params[:page], :per_page => 6).order("created_at desc")

        end

      end

  end



  def logout


    session[:user_login]= nil
    session[:user_account_name]= nil
    session[:user_login_id]= nil

    redirect_to :controller => :site, :action => :index

  end

  def create_account


      logger.info " #{params['name']}    #{params['login']}  and #{params['password']}  and email  #{params['email']} "

      if params['login'].blank? || params['password'].blank?
        render :inline => 'please input all required fields'
        return
      elsif !params['password'].eql?(params['password_repeat'])
        render :inline =>' password does not match'
        return
      else
        user = User.where("login = ?", params['login']).first
        if !user.nil?
          render :inline => 'user name already exist'
          return
        else
          user = User.new
          user.login = params['login']
          user.password = Digest::SHA1.hexdigest(params['password'])
          user.name = params['name']
          user.email = params['email']
          user.selected_style = 2

          if  user.save
            session[:user_login]=  user.login
            session[:user_login_id]=  user.id
            session[:user_account_name]=user.name
            render :inline => 'AccountOK'
            return

          else
            render :inline => 'Account Failed'
            return

          end

        end
      end

  end




  def myProfile

    @logged_users_profile_detail=nil

    if !session[:user_login_id].nil?

      @logged_users_profile_detail = User.where("id=?",session[:user_login_id]).first

    end

  end


end