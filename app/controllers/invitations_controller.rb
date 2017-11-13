class InvitationsController < ApplicationController
  layout "modal"
  # include InvitationsHelper
  before_action :require_logged_in
  before_action :set_list
  before_action :set_invitation, only: [:show, :destroy, :resend_invitation]

  def index
    @invitations = Invitation.all
  end

  def show
    render layout: 'modal'
  end

  def new
    @invitation = Invitation.new
    render layout: 'modal'
    # render layout: 'modal'
  end

  def create
          @invitation = Invitation.new(invitation_params)
          @invitation.sender_id = current_user.id
          # respond_to do |format|
            if @invitation.save
                if @invitation.recipient != nil
                    @url = login_url(:invitation_token => @invitation.token)
                    @recipient = @invitation.recipient
                    #send a notification email
                    InvitationMailer.existing_user_invite(@invitation, @url).deliver_now
                    unless @invitation.recipient.collaboration_lists.include?(@list)
                       hasCollaborationsList = @recipient.collaboration_lists.count > 0 ? true : false
                       @recipient.collaboration_lists.push(@list)  #add this user to the list as a collaborator
                       collaboratorSetting = ListsController.render(partial: "lists/collaboration_user_settings", locals: {list: @list,"collaboration_user": @recipient }).squish
                       html = ListsController.render(partial: "lists/collaboration_user", locals: {"collaboration_user": @recipient, "current_list": @list, "active_users": []}).squish
                      #  @invitation.update_attributes(:active => true)
                       htmlCollaborationsList = ListsController.render(partial: "lists/nav_list_name", layout: "li_navigation", locals: {list: @list, user: @recipient, active: false}).squish
                       ActionCable.server.broadcast 'invitation_channel', status: 'activated',id: @invitation.id, html: html, collaboratorSetting: collaboratorSetting, sender:@invitation.sender_id, recipient: @recipient.id, list_id: @list.id, htmlCollaborationsList: htmlCollaborationsList, hasCollaborationsList: hasCollaborationsList
                    end
                  else
                    @url = sign_up_url(:invitation_token => @invitation.token)
                    InvitationMailer.send_invitation(@invitation, @url).deliver_now #send the invite data to our mailer to deliver the email
                    invitationSetting = ListsController.render(partial: "lists/invited_user", locals: { "invited_user": @invitation, "list": @list }).squish
                    ActionCable.server.broadcast 'invitation_channel', status: 'inactive',id: @invitation.id, invitationSetting: invitationSetting, sender:@invitation.sender_id, recipient: @invitation.recipient_id, list_id: @list.id

                  end
                  # respond_to do |format|
                    flash[:notice] = "Thank you, invitation sent."
                    redirect_to list_path(@list)
                    # flash[:danger] = "We can't create the list."
                    # @htmlerrors = InvitationsController.render(partial: "shared/error_messages", locals: {"object": @invitation}).squish
                    # render :json => {:htmlerrors => @htmlerrors }
                    # format.js { render :action => "new" }
                  #  end
                # render action: show, layout: "modal"
                # format.js

            else

              @htmlerrors = InvitationsController.render(partial: "shared/error_messages", locals: {"object": @invitation}).squish
              respond_to do |format|
                format.json { render :json => {:htmlerrors => @htmlerrors }}
                format.js { render :action => "new" }
               end
            end
  end

  def resend_invitation
    byebug
    # @invitation = Invitation.find(id)
    @url = sign_up_url(:invitation_token => @invitation.token)
    InvitationMailer.send_invitation(@invitation, @url).deliver_now #send the invite
    flash[:notice] = "The invitation was resent."
    respond_to do |format|
      format.json { render :json => {:htmlerrors => @htmlerrors }}
      format.js { }
     end
  end

  # def edit
  #   @invitation = Invitation.find_by_token(token)
  #   if @invitation.sender
      #   if @invitation.save
      #     if logged_in?
      #       Mailer.deliver_invitation(@invitation, signup_url(@invitation.token))
      #       flash[:notice] = "Thank you, invitation sent."
      #       redirect_to @list
      #     else
      #       flash[:notice] = "Thank you, we will notify when we are ready."
      #       redirect_to root_url
      #     end
      #   else
      #     render :action => 'new'
      #   end
      # end
  # end


  # PATCH/PUT /invitations/1
  # PATCH/PUT /invitations/1.json
  # def update
  #   respond_to do |format|
  #     if @invitation.update(invitation_params)
  #       format.html { redirect_to @invitation, notice: 'Invitation was successfully updated.' }
  #       format.json { render :show, status: :ok, location: @invitation }
  #     else
  #       format.html { render :edit }
  #       format.json { render json: @invitation.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # DELETE /invitations/1
  # DELETE /invitations/1.json
  def destroy
    @invitation.destroy
    ActionCable.server.broadcast 'invitation_channel', status: 'deleted', id: @invitation.id
    respond_to do |format|
      flash[:notice] = 'Invitation was successfully destroyed.'
      format.html {   }
      format.json { head :no_content }
    end
  end

  private
    def set_invitation
      @invitation = Invitation.find(params[:id])
    end

    def set_list
      @list= List.find(params[:list_id])
    end

    def invitation_params
      params.require(:invitation).permit(:id,:sender_id, :list_id, :recipient_email, :token, :sent_at)
    end
end




# def create
#         @invitation = Invitation.new(invitation_params)
#         @invitation.sender_id = current_user.id
#         # respond_to do |format|
#           if @invitation.save
#               if @invitation.recipient != nil
#                   @url = login_url()
#                   @recipient = @invitation.recipient
#                   #send a notification email
#                   InvitationMailer.existing_user_invite(@invitation, @url).deliver_now
#                   unless @invitation.recipient.collaboration_lists.include?(@list)
#                      hasCollaborationsList = @recipient.collaboration_lists.count > 0 ? true : false
#                      @recipient.collaboration_lists.push(@list)  #add this user to the list as a collaborator
#                      collaboratorSetting = ListsController.render(partial: "lists/collaboration_user_settings", locals: { "collaboration_user": @recipient }).squish
#                      html = ListsController.render(partial: "lists/collaboration_user", locals: {"collaboration_user": @recipient, "current_list": @list, "active_users": []}).squish
#                     #  @invitation.update_attributes(:active => true)
#                      htmlCollaborationsList = ListsController.render(partial: "lists/nav_list_name", layout: "li_navigation", locals: {list: @list, user: @recipient, active: false}).squish
#                      ActionCable.server.broadcast 'invitation_channel', status: 'activated',id: @invitation.id, html: html, collaboratorSetting: collaboratorSetting, sender:@invitation.sender_id, recipient: @recipient.id, list_id: @list.id, htmlCollaborationsList: htmlCollaborationsList, hasCollaborationsList: hasCollaborationsList
#                   end
#                 else
#                   @url = sign_up_url(:invitation_token => @invitation.token)
#                   InvitationMailer.send_invitation(@invitation, @url).deliver_now #send the invite data to our mailer to deliver the email
#                   invitationSetting = ListsController.render(partial: "lists/invited_user", locals: { "invited_user": @invitation, "list": @list }).squish
#                   ActionCable.server.broadcast 'invitation_channel', status: 'inactive',id: @invitation.id, invitationSetting: invitationSetting, sender:@invitation.sender_id, recipient: @invitation.recipient_id, list_id: @list.id
#
#                 end
#                 # respond_to do |format|
#                   flash[:notice] = "Thank you, invitation sent."
#                   redirect_to list_path(@list)
#                   # flash[:danger] = "We can't create the list."
#                   # @htmlerrors = InvitationsController.render(partial: "shared/error_messages", locals: {"object": @invitation}).squish
#                   # render :json => {:htmlerrors => @htmlerrors }
#                   # format.js { render :action => "new" }
#                 #  end
#               # render action: show, layout: "modal"
#               # format.js
#
#           else
#
#             @htmlerrors = InvitationsController.render(partial: "shared/error_messages", locals: {"object": @invitation}).squish
#             respond_to do |format|
#               format.json { render :json => {:htmlerrors => @htmlerrors }}
#               format.js { render :action => "new" }
#              end
#           end
# end
