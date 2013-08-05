class ResumeController < ActionController::Base



  def index

    user_id=0;


    if !params[:user].nil?

      user_id=params[:user]

    end

    @user_avatar_ori =User.where("id=?",user_id ).first

    selected_skills =nil
    @selected_force =nil
    @selected_force_style1=""

    if !@user_avatar_ori.skills.nil?


      selected_skills = @user_avatar_ori.skills


      @selected_force = selected_skills.split(",")

      @selected_force =  @selected_force.delete_if{ |x| x.empty? }

      for skill  in @selected_force

        @selected_force_style1 = @selected_force_style1 +  skill+" ; "

      end

    end



  end


  def per_resume





  end



end