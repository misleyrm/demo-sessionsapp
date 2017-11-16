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
          @invitation.update_attributes(:active => true)
          unless user.collaboration_lists.include?(@list)
             user.collaboration_lists.push(@list)  #add this user to the list as a collaborator         current_list,     collaboration_user
          end
          htmlCollaborationUser = ListsController.render(partial: "lists/collaboration_user", locals: {"collaboration_user": user, "current_list": @list,"active_users": [], "current_user": current_user}).squish
          # ActionCable.server.broadcast 'invitation_channel', status: 'activated', html: html,  user: user.id, list_id: @list.id

          # html = ListsController.render(partial: "lists/collaboration_user", locals: {"collaboration_user": user, "current_list": @list, "active_users": []}).squish
          # invitationSetting = ListsController.render(partial: "lists/invited_user", locals: { "invited_user": @invitation, "list": @list }).squish
          htmlCollaboratorSetting = ListsController.render(partial: "lists/collaboration_user_settings", locals: {"list": @list, "collaboration_user": user }).squish
          htmlCollaborationsList = ""
          ActionCable.server.broadcast 'invitation_channel', status: 'activated',id: @invitation.id, htmlCollaborationUser: htmlCollaborationUser, htmlCollaboratorSetting: htmlCollaboratorSetting, owner: @list.owner.id, sender:@invitation.sender_id, recipient: @invitation.recipient_id, list_id: @list.id, htmlCollaborationsList: htmlCollaborationsList


        end
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_to root_url
      elsif user && !user.activated
        user.update_activation_digest
        user.send_activation_email
        flash[:danger] = "Account not activated. You need to activate your account first."
        flash[:danger] += " Check your email for the activation link."
        render 'new'
        # redirect_to(
        #   new_password_reset_url,
        #   notice: %Q[Your account has not been activated yet. Check your email to activate account or click here to re-send #{view_context.link_to("activation", users_resend_activation_url(:email => user.email), :method => :post )}],
        #   flash: { html_safe: true }
        #   )

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
      flash[:success] = 'Logged out successfully.'
      redirect_to confirmation_page_url
    end

    def confirmation

    end


end
