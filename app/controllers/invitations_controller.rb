class InvitationsController < ApplicationController
  layout "modal"
  before_action :require_logged_in
  before_action :set_list
  before_action :set_invitation, only: [:show]

  def index
    @invitations = Invitation.all
  end

  def show
    render layout: 'modal'
  end

  def new
    @invitation = Invitation.new
    # render layout: 'modal'
  end

  def create
    @invitation = Invitation.new(invitation_params)
    @invitation.sender_id = current_user.id
    # byebug
    # respond_to do |format|
        if @invitation.save
          if @invitation.recipient != nil
              @url = login_url()
              #send a notification email
              InvitationMailer.existing_user_invite(@invitation, @url).deliver_now
              unless @invitation.recipient.collaboration_lists.include?(@list)
                 hasCollaborationsList = User.first.collaboration_lists.count > 0 ? true : false
                 @invitation.recipient.collaboration_lists.push(@list)  #add this user to the list as a collaborator
                 html = ListsController.render(partial: "lists/collaboration_user", locals: {"collaboration_user": @invitation.recipient, "current_list": @list}).squish
                 byebug
                 htmlCollaborationsList = ListsController.render(partial: "lists/nav_list_name", layout: "lists/li_navigation", locals: { "list": @list}).squish
                 ActionCable.server.broadcast 'invitation_channel', status: 'activated', html: html,  user: @invitation.recipient.id, list_id: @list.id, htmlCollaborationsList: htmlCollaborationsList, hasCollaborationsList: hasCollaborationsList
              end
            else
              # byebug
              @url = sign_up_url(:invitation_token => @invitation.token)
              InvitationMailer.send_invitation(@invitation, @url).deliver_now #send the invite data to our mailer to deliver the email
            end

          flash[:notice] = "Thank you, invitation sent."
          # render action: show, layout: "modal"
          # format.js

        else
          #format.html { redirect_to new_list_invitation_url(@list), notice: "Thank you, we will notify when we are ready." }
          # format.js
        end
          # end
    # end
  end

  def edit
    @invitation = Invitation.find_by_token(token)
    if @invitation.sender
    if @invitation.save
      if logged_in?
        Mailer.deliver_invitation(@invitation, signup_url(@invitation.token))
        flash[:notice] = "Thank you, invitation sent."
        redirect_to @list
      else
        flash[:notice] = "Thank you, we will notify when we are ready."
        redirect_to root_url
      end
    else
      render :action => 'new'
    end
  end
end


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
    respond_to do |format|
      format.html { redirect_to invitations_url, notice: 'Invitation was successfully destroyed.' }
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
