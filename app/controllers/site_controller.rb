class SiteController < ApplicationController

  include ApplicationHelper


  def index



    test_database = ActiveRecord::Base.connection.tables

    for t in test_database

      logger.info "we have table #{t}"

    end


    @user_articles_images = Array.new

    @count=1

    @usersResumes =nil


    if !params[:tag].nil?  &&   params[:all]!="true"

      @usersResumes = User.tagged_with(params[:tag]).paginate(:page => params[:page], :per_page => 8).order("rate_number desc")


    else

      @usersResumes = User.paginate(:page => params[:page], :per_page => 8).order("rate_number desc")



    end


    #@usersResumes = User.limit(10).order("rate_number desc").all


    users = User.limit(50).order("updated_at desc").all

      for user in users

        user_article_hash = Hash.new

        userArticle = user.articles.limit(1).order('updated_at desc').all

        user_article_hash[:article]= userArticle[0]

        user_article_hash[:owner]= user.name

        for art in userArticle

         images = art.attachments.where("attfile_content_type like ?","image%").limit(1).order('created_at desc')

         user_article_hash[:content]=art.content
         user_article_hash[:title]=art.title

         user_article_hash[:created_at]= art.created_at.to_s.split(" ")[0]

         if  !images[0].nil?

           user_article_hash[:image]=images[0].attfile.url(:original)

         end

        end

        if !user_article_hash[:content].nil?

          @user_articles_images <<   user_article_hash

        end

      end

    #render :inline => @user_articles_images.to_json

  end



  def allProjects


    session[:index_page]="no"

    @user_articles =nil


    if !params[:tag].nil?  &&   params[:all]!="true"

      @user_articles = Article.tagged_with(params[:tag]).paginate(:page => params[:page], :per_page => 6).order("created_at desc")


    elsif !params[:user_project_id].nil?


      user_project_view= User.find_by_id(params[:user_project_id])

      @user_articles = user_project_view.articles.paginate(:page => params[:page], :per_page => 6).order("created_at desc")


    else

      @user_articles = Article.paginate(:page => params[:page], :per_page => 6).order("created_at desc")



    end


    #@user_articles=Array.new
    #
    #
    #
    #article = Article.order("created_at desc").all
    #
    #
    #for per in article
    #
    #  userWithArticles= Hash.new
    #
    #
    #  user = User.find_by_sql "select * from users u where u.id = (select a.user_id from articles_users a where a.article_id = #{per.id} limit 1)"
    #
    #
    #  userWithArticles[:article] =per
    #
    #
    #  images = per.attachments.where("attfile_content_type like ?","image%").limit(1).order('created_at desc')
    #
    #
    #
    #  if  !images[0].nil?
    #
    #    userWithArticles[:image]=images[0].attfile.url(:small)
    #    userWithArticles[:image_details]=images[0]
    #
    #  end
    #
    #
    #
    #  userWithArticles[:user]= user[0]
    #
    #  if !userWithArticles[:user].nil? && user[0].avatar_file_name!=""
    #
    #
    #    userWithArticles[:userAvatar]= user[0].avatar.url(:thumb_small)
    #
    #  end
    #
    #  @user_articles << userWithArticles
    #
    #
    #end





    #render :json => @user_articles


  end

  def article_detail


    session[:index_page]="no"


    @article_detail_info =   Article.where("id=?",params[:article_info]).first


    @comments = @article_detail_info.comments.order("created_at asc").paginate(:page => params[:page], :per_page => 8)


    user= User.find_by_sql "select * from users u where u.id = (select a.user_id from articles_users a where a.article_id = #{@article_detail_info.id} limit 1)"

    @article_author =user[0]
    @article_author_avatar=nil

    if !@article_author.nil? && @article_author.avatar_file_name!=""


      @article_author_avatar= @article_author.avatar.url(:thumb_small)

    end

    #render :json => @article_author

  end


  def vote_article


     if !params[:article_id].nil?  and !params[:use_id].nil?  and  params[:vote_choice]=="like"


       article_votable = Article.find_by_id(params[:article_id])



       user_voter = User.find_by_id(params[:use_id])


       article_votable.liked_by user_voter



       logger.info "now we vote for  #{article_votable.title}, now we have like  vote number #{article_votable.likes.size} "




       if !article_votable.vote_registered?


         render :inline =>"You cannot vote more than once...that is cheating. :)"


       else

         if !params[:article_author_id].nil?


           article_author = User.find_by_id(params[:article_author_id])

           rate_number= article_author.rate_number


          if rate_number.to_i >0


            article_author.update_attribute(:rate_number,rate_number+article_votable.likes.size)

          end


           logger.info "now we have vote number total  #{article_author.rate_number}"

         end

         render :inline =>"vote ok"


       end




     elsif   !params[:article_id].nil?  and !params[:use_id].nil?  and  params[:vote_choice]=="dislike"


       article_votable = Article.find_by_id(params[:article_id])



       user_voter = User.find_by_id(params[:use_id])


       article_votable.disliked_by user_voter






       logger.info "now we vote for  #{article_votable.title}, now we have dislike  vote number #{article_votable.dislikes.size} "

       if !article_votable.vote_registered?


         render :inline =>"You cannot vote more than once...that is cheating. :)"


       else


         if !params[:article_author_id].nil?


           article_author = User.find_by_id(params[:article_author_id])

           rate_number= article_author.rate_number



           if rate_number.to_i>0

             article_author.update_attribute(:rate_number,rate_number-article_votable.dislikes.size)

           end


           logger.info "now we have vote number total  #{article_author.rate_number}"

         end

         render :inline =>"vote ok"


       end



     else

       render :inline =>"Vote unsuccessfully, please register or login to vote :)"

     end



     #To check if a vote counted, or registered, use vote_registered? on your model after voting. For example:
     #
     # article_votable.liked_by @user
     #article_votable.vote_registered? # => true
     #
     #article_votable.liked_by => @user
     #article_votable.vote_registered? # => false, because @user has already voted this way
     #
     #article_votable.disliked_by @user
     #article_votable.vote_registered? # => true, because user changed their vote
     #
     #article_votable.votes.size # => 1
     #article_votable.positives.size # => 0
     #article_votable.negatives.size # => 1

  end



  def article_comment


    if !params[:article_id].nil? and !params[:content].nil?  and !session[:user_login_id].nil?

      logger.info "received params  #{params[:article_id]}   and #{params[:content]}"


      commentable_article = Article.find_by_id(params[:article_id])

      commentable_article.comments.create(:title => "nil", :comment => params[:content], :user_id=>session[:user_login_id])


      render :inline =>"comment post ok"

    else

      render :inline =>"comment post failed..please login to post"


    end




  end


end