class LoginController < ApplicationController
  include LoginHelper

  def new
    gon.current_user = current_user
    @token = params[:invitation_token]
  end

  def create
      user = User.find_by_email(params[:session][:email].downcase)
      # If the user exists AND the password entered is correct.
      if user && user.authenticate(params[:session][:password]) && user.activated
        # Save the user id inside the browser cookie. This is how we keep the user
        # logged in when they navigate around our website.
        @token = params[:invitation_token]
        @invitation = Invitation.find_by_token(@token)
        if (!@token.nil?)&&(user.email==@invitation.recipient_email)
          @list = List.find(@invitation.list_id)
          # byebug
          unless user.collaboration_lists.include?(@list)
             user.collaboration_lists.push(@list)  #add this user to the list as a collaborator         current_list,     collaboration_user
             html = ListsController.render(partial: "lists/collaboration_user", locals: {"collaboration_user": user, "current_list": @list}).squish
             ActionCable.server.broadcast 'invitation_channel', status: 'activated', html: html,  user: user.id, list_id: @list.id
          end
        end
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_to root_url
      elsif user && !user.activated
        redirect_to(
          new_password_reset_url,
          notice: %Q[Your account has not been activated yet. Check your email to activate account or click here to re-send #{view_context.link_to("activation", users_resend_activation_url(:email => user.email), :method => :post )}],
          flash: { html_safe: true }
          )

      else
      # If user's login doesn't work, send them back to the login form.
        flash.now[:danger] = 'Invalid email or password combination'
        render 'new'
        # redirect_to '/login'
      end
    end

    def destroy
      # session[:user_id] = nil
      # redirect_to '/login'
      log_out if logged_in?
      redirect_to root_url
    end
end
