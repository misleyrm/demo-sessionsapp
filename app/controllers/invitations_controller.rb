class InvitationsController < ApplicationController
  layout "modal"
  # include InvitationsHelper
  before_action :require_logged_in
  before_action :set_list
  before_action :set_invitation, only: [:show, :destroy, :resend_invitation, :update]

  def index
    @invitations = Invitation.all.sort_by(&:created_at)
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
                    #  hasCollaborationsList = @recipient.collaboration_lists.count > 0 ? true : false
                     @recipient.collaboration_lists.push(@list)  #add this user to the list as a collaborator
                     htmlCollaboratorSetting = ListsController.render(partial: "lists/list_members", locals: {list: @list,"member": @recipient }).squish
                     htmlInvitationSetting = ListsController.render(partial: "lists/list_pending_invitation", locals: {list: @list,"pending_invitation": @invitation }).squish
                     htmlCollaborationUser = ListsController.render(partial: "lists/collaboration_user", locals: {"collaboration_user": @recipient, "current_list": @list, "active_users": [],current_user: current_user}).squish
                    #  htmlCollaborationsList = ListsController.render(partial: "lists/nav_list_name", layout: "li_navigation", locals: {list: @list, user: @recipient, active: false}).squish
                    # htmlCollaborationsList: htmlCollaborationsList, hasCollaborationsList: hasCollaborationsList,
                     htmlUserPendingInvitation = UsersController.render(partial: "users/pending_invitation", locals: {pending_invitation: @invitation}).squish
                     ActionCable.server.broadcast 'invitation_channel', status: 'created',id: @invitation.id, htmlCollaborationUser: htmlCollaborationUser, htmlCollaboratorSetting: htmlCollaboratorSetting, htmlInvitationSetting: htmlInvitationSetting, sender:@invitation.sender_id, recipient: @recipient.id, list_id: @list.id, owner: @list.owner.id, existing_user_invite: true, htmlUserPendingInvitation: htmlUserPendingInvitation
                  end
                else
                  @url = sign_up_url(:invitation_token => @invitation.token)
                  InvitationMailer.send_invitation(@invitation, @url).deliver_now #send the invite data to our mailer to deliver the email
                  htmlInvitationSetting = ListsController.render(partial: "lists/list_pending_invitation", locals: { "pending_invitation": @invitation, "list": @list }).squish
                  ActionCable.server.broadcast 'invitation_channel', status: 'created',id: @invitation.id, htmlInvitationSetting: htmlInvitationSetting, sender:@invitation.sender_id, recipient: @invitation.recipient_id, list_id: @list.id, existing_user_invite: false

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
          respond_to do |format|
            @htmlerrors = InvitationsController.render(partial: "shared/error_messages", locals: {"object": @invitation}).squish
            flash[:notice] = "We can't create the list."
            format.json { render :json => {:htmlerrors => @htmlerrors  }}
            format.js { }
          end
          # # flash[:danger] = "We can't create the list."
          # @htmlerrors = InvitationsController.render(partial: "shared/error_messages", locals: {"object": @invitation}).squish
          # # render :json => {:htmlerrors => @htmlerrors }
          # render :action => "new", layout: "modal"
        end
  end

  def update

    @user = current_user
    @token = params[:invitation_token]
    if (!@token.nil?) && (@user == @invitation.recipient)
        # @list = List.find(@invitation.list_id)
        @invitation.update_attributes(:active => true)
        @collaboration = Collaboration.find_by(list_id: @list.id,user_id: @user.id)
        @collaboration.update_attributes(:collaboration_date => Time.now)
        hasCollaborationsList = @user.collaboration_lists.count > 0 ? true : false
        unless @user.collaboration_lists.include?(@list)
           @user.collaboration_lists.push(@list)  #add this user to the list as a collaborator
        end
        htmlCollaborationUser = ListsController.render(partial: "lists/collaboration_user", locals: {"collaboration_user": @user, "current_list": @list,"active_users": [], "current_user": @user}).squish
        htmlCollaboratorSetting = ListsController.render(partial: "lists/collaboration_user_settings", locals: {"list": @list, "collaboration_user": @user }).squish
        htmlCollaborationsList = ListsController.render(partial: "lists/nav_list_name", layout: "li_navigation", locals: {list: @list, user: @user, active: false}).squish
        htmlUserAcceptedInvitation = UsersController.render(partial: "users/accepted_invitation", locals: {accepted_invitation: @invitation}).squish
        ActionCable.server.broadcast 'invitation_channel', status: 'activated',id: @invitation.id, htmlCollaborationUser: htmlCollaborationUser, htmlCollaboratorSetting: htmlCollaboratorSetting, owner: @list.owner.id, sender:@invitation.sender_id, recipient: @invitation.recipient.id, list_id: @list.id, htmlCollaborationsList: htmlCollaborationsList, hasCollaborationsList: hasCollaborationsList, htmlUserAcceptedInvitation: htmlUserAcceptedInvitation
        respond_to do |format|
          @htmlerrors = InvitationsController.render(partial: "shared/error_messages", locals: {"object": @invitation}).squish
          flash[:notice] = "The invitation accepted."
          format.json { render :json => {:htmlerrors => @htmlerrors  }}
          format.js { }
         end

    end

  end


  def resend_invitation
    # @invitation = Invitation.find(id)
    if (@invitation.recipient != nil) || (User.find_by_email(@invitation.recipient_email))
      @url = login_url(:invitation_token => @invitation.token)
      # @recipient = @invitation.recipient
      #send a notification email
      InvitationMailer.existing_user_invite(@invitation, @url).deliver_now
    else
      @url = sign_up_url(:invitation_token => @invitation.token)
      InvitationMailer.send_invitation(@invitation, @url).deliver_now #send the invite
      flash[:notice] = "The invitation was re-sent."
      respond_to do |format|
        format.json { render :json => {:htmlerrors => @htmlerrors }}
        format.js { }
       end
     end

  end

  # DELETE /invitations/1
  # DELETE /invitations/1.json
  def destroy
    @invitation.destroy
    if (@invitation.recipient != nil) && (!@invitation.active)
      @collaboration = Collaboration.find_by(user_id: @invitation.recipient.id, list_id: @invitation.list_id)
      @collaboration.destroy
    end
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
